#!/bin/bash
# 🔍 AI Data Classification Script
# Automated data classification for AI training datasets
# Version: 1.0

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="${SCRIPT_DIR}/../config/classification-rules.yaml"
LOG_FILE="${SCRIPT_DIR}/../logs/classification-$(date +%Y%m%d).log"
REPORT_DIR="${SCRIPT_DIR}/../reports"

# Classification levels
declare -A CLASSIFICATION_LEVELS=(
    ["L1"]="🔴 Restricted"
    ["L2"]="🟡 Confidential" 
    ["L3"]="🟢 Internal"
    ["L4"]="🔵 Public"
)

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Usage function
usage() {
    cat << EOF
🔍 AI Data Classification Tool

Usage: $0 [OPTIONS] <input_path>

OPTIONS:
    -t, --type       Data type (file, directory, database, api)
    -f, --format     Data format (csv, json, parquet, text, image, audio)
    -s, --sector     Sector (clinic, family-office, msp, general)
    -o, --output     Output format (console, json, yaml, csv)
    -r, --report     Generate detailed classification report
    -v, --verbose    Verbose output
    -h, --help       Show this help message

EXAMPLES:
    # Classify a CSV file
    $0 -t file -f csv -s clinic ./patient-data.csv

    # Classify directory with reporting
    $0 -t directory -s family-office -r ./financial-data/

    # Classify and output JSON
    $0 -t file -f json -o json ./customer-records.json

CLASSIFICATION LEVELS:
    L1 🔴 Restricted   - Personal health data, financial records, biometric data
    L2 🟡 Confidential - Personal identifiers, customer data, proprietary algorithms  
    L3 🟢 Internal     - Business communications, operational metrics, employee data
    L4 🔵 Public       - Marketing materials, published research, public statements

EOF
}

# Logging function
log() {
    local level=$1
    shift
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $*" | tee -a "$LOG_FILE"
}

# Classification patterns
classify_content() {
    local content="$1"
    local file_path="$2"
    local sector="$3"
    
    local score_l1=0
    local score_l2=0
    local score_l3=0
    local score_l4=0
    
    # L1 - Restricted patterns
    if echo "$content" | grep -qiE "(ssn|social security|credit card|passport|driver.*license)"; then
        ((score_l1 += 10))
    fi
    
    if echo "$content" | grep -qiE "(patient|medical|health|diagnosis|prescription|treatment)"; then
        ((score_l1 += 8))
    fi
    
    if echo "$content" | grep -qiE "(account.*number|routing.*number|iban|swift|bank.*account)"; then
        ((score_l1 += 10))
    fi
    
    if echo "$content" | grep -qiE "(biometric|fingerprint|retina|facial.*recognition|dna)"; then
        ((score_l1 += 10))
    fi
    
    # L2 - Confidential patterns  
    if echo "$content" | grep -qiE "(email.*address|phone.*number|address|zip.*code)"; then
        ((score_l2 += 5))
    fi
    
    if echo "$content" | grep -qiE "(customer.*id|client.*id|user.*id|employee.*id)"; then
        ((score_l2 += 4))
    fi
    
    if echo "$content" | grep -qiE "(confidential|proprietary|trade.*secret|internal.*use)"; then
        ((score_l2 += 6))
    fi
    
    # L3 - Internal patterns
    if echo "$content" | grep -qiE "(meeting|internal.*communication|employee.*data)"; then
        ((score_l3 += 3))
    fi
    
    if echo "$content" | grep -qiE "(performance.*metric|operational.*data|system.*log)"; then
        ((score_l3 += 3))
    fi
    
    # L4 - Public patterns
    if echo "$content" | grep -qiE "(public|published|marketing|press.*release)"; then
        ((score_l4 += 2))
    fi
    
    # Sector-specific adjustments
    case "$sector" in
        "clinic")
            if echo "$content" | grep -qiE "(patient|medical|health|hipaa)"; then
                ((score_l1 += 5))
            fi
            ;;
        "family-office")
            if echo "$content" | grep -qiE "(investment|portfolio|financial|client.*assets)"; then
                ((score_l2 += 5))
            fi
            ;;
        "msp")
            if echo "$content" | grep -qiE "(client.*data|service.*agreement|multi.*tenant)"; then
                ((score_l2 += 3))
            fi
            ;;
    esac
    
    # File path analysis
    if echo "$file_path" | grep -qiE "(personal|private|confidential|restricted)"; then
        ((score_l1 += 3))
    fi
    
    if echo "$file_path" | grep -qiE "(internal|employee|staff)"; then
        ((score_l3 += 2))
    fi
    
    if echo "$file_path" | grep -qiE "(public|marketing|www)"; then
        ((score_l4 += 2))
    fi
    
    # Determine classification
    local max_score=0
    local classification=""
    
    if [ $score_l1 -gt $max_score ]; then
        max_score=$score_l1
        classification="L1"
    fi
    
    if [ $score_l2 -gt $max_score ]; then
        max_score=$score_l2
        classification="L2"
    fi
    
    if [ $score_l3 -gt $max_score ]; then
        max_score=$score_l3
        classification="L3"
    fi
    
    if [ $score_l4 -gt $max_score ]; then
        max_score=$score_l4
        classification="L4"
    fi
    
    # Default to L3 if no clear classification
    if [ -z "$classification" ] || [ $max_score -eq 0 ]; then
        classification="L3"
        max_score=1
    fi
    
    echo "$classification:$max_score:$score_l1:$score_l2:$score_l3:$score_l4"
}

# File classification function
classify_file() {
    local file_path="$1"
    local file_format="$2"
    local sector="$3"
    local verbose="$4"
    
    if [ ! -f "$file_path" ]; then
        log "ERROR" "File not found: $file_path"
        return 1
    fi
    
    local content=""
    local file_size=$(stat -f%z "$file_path" 2>/dev/null || stat -c%s "$file_path" 2>/dev/null)
    
    # Size-based initial assessment
    if [ "$file_size" -gt 104857600 ]; then  # 100MB
        log "WARN" "Large file detected: $file_path ($file_size bytes)"
        # Sample first 1MB for large files
        content=$(head -c 1048576 "$file_path" | strings | head -1000)
    else
        # Read entire file for smaller files
        case "$file_format" in
            "csv"|"json"|"text"|"yaml"|"xml")
                content=$(cat "$file_path")
                ;;
            "parquet")
                # Requires parquet-tools
                if command -v parquet-tools >/dev/null 2>&1; then
                    content=$(parquet-tools cat "$file_path" | head -1000)
                else
                    log "WARN" "parquet-tools not available, using binary analysis"
                    content=$(strings "$file_path" | head -1000)
                fi
                ;;
            *)
                # Use strings for binary files
                content=$(strings "$file_path" | head -1000)
                ;;
        esac
    fi
    
    # Perform classification
    local result=$(classify_content "$content" "$file_path" "$sector")
    local classification=$(echo "$result" | cut -d: -f1)
    local confidence=$(echo "$result" | cut -d: -f2)
    local scores=$(echo "$result" | cut -d: -f3-6)
    
    # Output results
    case "$classification" in
        "L1") echo -e "${RED}${CLASSIFICATION_LEVELS[$classification]}${NC}" ;;
        "L2") echo -e "${YELLOW}${CLASSIFICATION_LEVELS[$classification]}${NC}" ;;
        "L3") echo -e "${GREEN}${CLASSIFICATION_LEVELS[$classification]}${NC}" ;;
        "L4") echo -e "${BLUE}${CLASSIFICATION_LEVELS[$classification]}${NC}" ;;
    esac
    
    if [ "$verbose" = "true" ]; then
        echo "  File: $file_path"
        echo "  Size: $file_size bytes"
        echo "  Confidence: $confidence"
        echo "  Scores (L1:L2:L3:L4): $scores"
        echo ""
    fi
    
    # Return structured data for reporting
    echo "$file_path,$classification,$confidence,$file_size,$scores"
}

# Directory classification function
classify_directory() {
    local dir_path="$1"
    local sector="$2"
    local verbose="$3"
    local output_format="$4"
    
    if [ ! -d "$dir_path" ]; then
        log "ERROR" "Directory not found: $dir_path"
        return 1
    fi
    
    local temp_results="/tmp/classification_results_$$.csv"
    echo "file_path,classification,confidence,file_size,l1_score,l2_score,l3_score,l4_score" > "$temp_results"
    
    log "INFO" "Scanning directory: $dir_path"
    
    # Find all files (excluding hidden files and common exclusions)
    find "$dir_path" -type f \
        ! -path "*/.*" \
        ! -name "*.log" \
        ! -name "*.tmp" \
        ! -name "*.bak" \
        | while read -r file; do
        
        # Detect file format
        local file_format="text"
        case "${file##*.}" in
            csv) file_format="csv" ;;
            json) file_format="json" ;;
            parquet) file_format="parquet" ;;
            txt|md) file_format="text" ;;
            yaml|yml) file_format="yaml" ;;
            xml) file_format="xml" ;;
            jpg|jpeg|png|gif) file_format="image" ;;
            mp3|wav|flac) file_format="audio" ;;
            mp4|avi|mov) file_format="video" ;;
        esac
        
        if [ "$verbose" = "true" ]; then
            echo "Analyzing: $file"
        fi
        
        local result=$(classify_file "$file" "$file_format" "$sector" "false")
        if [ $? -eq 0 ]; then
            echo "$result" >> "$temp_results"
        fi
    done
    
    # Generate summary report
    local total_files=$(tail -n +2 "$temp_results" | wc -l)
    local l1_count=$(tail -n +2 "$temp_results" | grep ",L1," | wc -l)
    local l2_count=$(tail -n +2 "$temp_results" | grep ",L2," | wc -l)
    local l3_count=$(tail -n +2 "$temp_results" | grep ",L3," | wc -l)
    local l4_count=$(tail -n +2 "$temp_results" | grep ",L4," | wc -l)
    
    echo ""
    echo "📊 Classification Summary for: $dir_path"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "Total Files: $total_files"
    echo -e "${RED}L1 Restricted:${NC} $l1_count files"
    echo -e "${YELLOW}L2 Confidential:${NC} $l2_count files" 
    echo -e "${GREEN}L3 Internal:${NC} $l3_count files"
    echo -e "${BLUE}L4 Public:${NC} $l4_count files"
    echo ""
    
    # Output in requested format
    case "$output_format" in
        "json")
            echo "{"
            echo "  \"directory\": \"$dir_path\","
            echo "  \"total_files\": $total_files,"
            echo "  \"classification_summary\": {"
            echo "    \"L1_restricted\": $l1_count,"
            echo "    \"L2_confidential\": $l2_count,"
            echo "    \"L3_internal\": $l3_count,"
            echo "    \"L4_public\": $l4_count"
            echo "  },"
            echo "  \"files\": ["
            tail -n +2 "$temp_results" | while IFS=, read -r file_path classification confidence file_size l1 l2 l3 l4; do
                echo "    {"
                echo "      \"path\": \"$file_path\","
                echo "      \"classification\": \"$classification\","
                echo "      \"confidence\": $confidence,"
                echo "      \"file_size\": $file_size,"
                echo "      \"scores\": {\"L1\": $l1, \"L2\": $l2, \"L3\": $l3, \"L4\": $l4}"
                echo "    }$([ $(tail -n +2 "$temp_results" | wc -l) -gt 1 ] && echo ",")"
            done
            echo "  ]"
            echo "}"
            ;;
        "csv")
            cat "$temp_results"
            ;;
        *)
            if [ "$verbose" = "true" ]; then
                echo ""
                echo "📄 Detailed Results:"
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                tail -n +2 "$temp_results" | while IFS=, read -r file_path classification confidence file_size l1 l2 l3 l4; do
                    case "$classification" in
                        "L1") echo -e "${RED}$classification${NC} $file_path (confidence: $confidence)" ;;
                        "L2") echo -e "${YELLOW}$classification${NC} $file_path (confidence: $confidence)" ;;
                        "L3") echo -e "${GREEN}$classification${NC} $file_path (confidence: $confidence)" ;;
                        "L4") echo -e "${BLUE}$classification${NC} $file_path (confidence: $confidence)" ;;
                    esac
                done
            fi
            ;;
    esac
    
    rm -f "$temp_results"
}

# Generate classification report
generate_report() {
    local input_path="$1"
    local sector="$2"
    local report_file="$REPORT_DIR/classification-report-$(date +%Y%m%d-%H%M%S).html"
    
    mkdir -p "$REPORT_DIR"
    
    cat > "$report_file" << EOF
<!DOCTYPE html>
<html>
<head>
    <title>AI Data Classification Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .header { background: #f4f4f4; padding: 20px; border-radius: 8px; }
        .classification { padding: 10px; margin: 5px; border-radius: 4px; }
        .l1 { background: #ffebee; border-left: 4px solid #f44336; }
        .l2 { background: #fff8e1; border-left: 4px solid #ff9800; }
        .l3 { background: #e8f5e8; border-left: 4px solid #4caf50; }
        .l4 { background: #e3f2fd; border-left: 4px solid #2196f3; }
        table { width: 100%; border-collapse: collapse; margin: 20px 0; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background-color: #f4f4f4; }
    </style>
</head>
<body>
    <div class="header">
        <h1>🔍 AI Data Classification Report</h1>
        <p><strong>Generated:</strong> $(date)</p>
        <p><strong>Target:</strong> $input_path</p>
        <p><strong>Sector:</strong> $sector</p>
    </div>
    
    <h2>Classification Levels</h2>
    <div class="classification l1">🔴 <strong>L1 - Restricted:</strong> Personal health data, financial records, biometric data</div>
    <div class="classification l2">🟡 <strong>L2 - Confidential:</strong> Personal identifiers, customer data, proprietary algorithms</div>
    <div class="classification l3">🟢 <strong>L3 - Internal:</strong> Business communications, operational metrics, employee data</div>
    <div class="classification l4">🔵 <strong>L4 - Public:</strong> Marketing materials, published research, public statements</div>
    
    <h2>Recommendations</h2>
    <ul>
        <li><strong>L1 Data:</strong> Implement strongest encryption, access controls, and audit logging</li>
        <li><strong>L2 Data:</strong> Use encryption and role-based access controls</li>
        <li><strong>L3 Data:</strong> Standard corporate security measures</li>
        <li><strong>L4 Data:</strong> Basic protection, focus on integrity and availability</li>
    </ul>
    
    <p><em>For detailed implementation guidance, see the ai-data-handling-kit documentation.</em></p>
</body>
</html>
EOF
    
    log "INFO" "Report generated: $report_file"
    echo "📄 Report saved to: $report_file"
}

# Main function
main() {
    local input_path=""
    local data_type="file"
    local data_format="text"
    local sector="general"
    local output_format="console"
    local generate_report_flag="false"
    local verbose="false"
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -t|--type)
                data_type="$2"
                shift 2
                ;;
            -f|--format)
                data_format="$2"
                shift 2
                ;;
            -s|--sector)
                sector="$2"
                shift 2
                ;;
            -o|--output)
                output_format="$2"
                shift 2
                ;;
            -r|--report)
                generate_report_flag="true"
                shift
                ;;
            -v|--verbose)
                verbose="true"
                shift
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            *)
                if [ -z "$input_path" ]; then
                    input_path="$1"
                else
                    echo "Error: Unexpected argument: $1"
                    usage
                    exit 1
                fi
                shift
                ;;
        esac
    done
    
    # Validate required arguments
    if [ -z "$input_path" ]; then
        echo "Error: Input path is required"
        usage
        exit 1
    fi
    
    # Create necessary directories
    mkdir -p "$(dirname "$LOG_FILE")" "$REPORT_DIR"
    
    log "INFO" "Starting classification of: $input_path"
    log "INFO" "Type: $data_type, Format: $data_format, Sector: $sector"
    
    # Perform classification based on type
    case "$data_type" in
        "file")
            classify_file "$input_path" "$data_format" "$sector" "$verbose"
            ;;
        "directory")
            classify_directory "$input_path" "$sector" "$verbose" "$output_format"
            ;;
        *)
            log "ERROR" "Unsupported data type: $data_type"
            exit 1
            ;;
    esac
    
    # Generate report if requested
    if [ "$generate_report_flag" = "true" ]; then
        generate_report "$input_path" "$sector"
    fi
    
    log "INFO" "Classification completed successfully"
}

# Run main function with all arguments
main "$@"

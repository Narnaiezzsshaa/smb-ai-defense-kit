#!/usr/bin/env python3
"""
🔒 AI Content Redaction Tool
Automated PII detection and redaction for AI training data and model outputs
Version: 1.0
"""

import re
import json
import csv
import sys
import argparse
import hashlib
import logging
from pathlib import Path
from typing import Dict, List, Tuple, Optional, Any
from datetime import datetime
import pandas as pd

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('redaction.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

class AIContentRedactor:
    """Main redaction engine for AI content"""
    
    def __init__(self, config_path: Optional[str] = None):
        self.config = self._load_config(config_path)
        self.redaction_patterns = self._initialize_patterns()
        self.redaction_log = []
        
    def _load_config(self, config_path: Optional[str]) -> Dict[str, Any]:
        """Load redaction configuration"""
        default_config = {
            "redaction_char": "█",
            "preserve_format": True,
            "log_redactions": True,
            "hash_original": True,
            "sectors": {
                "clinic": {
                    "strict_mode": True,
                    "additional_patterns": ["medical_record", "patient_id"]
                },
                "family-office": {
                    "strict_mode": True,
                    "additional_patterns": ["account_number", "investment_id"]
                },
                "msp": {
                    "strict_mode": False,
                    "additional_patterns": ["client_id", "service_ticket"]
                }
            }
        }
        
        if config_path and Path(config_path).exists():
            with open(config_path, 'r') as f:
                user_config = json.load(f)
                default_config.update(user_config)
        
        return default_config
    
    def _initialize_patterns(self) -> Dict[str, Dict]:
        """Initialize PII detection patterns"""
        return {
            "ssn": {
                "pattern": r'\b\d{3}-?\d{2}-?\d{4}\b',
                "name": "Social Security Number",
                "sensitivity": "L1",
                "replacement": "███-██-████"
            },
            "credit_card": {
                "pattern": r'\b(?:\d{4}[-\s]?){3}\d{4}\b',
                "name": "Credit Card Number", 
                "sensitivity": "L1",
                "replacement": "████-████-████-████"
            },
            "phone": {
                "pattern": r'\b(?:\+?1[-.\s]?)?\(?([0-9]{3})\)?[-.\s]?([0-9]{3})[-.\s]?([0-9]{4})\b',
                "name": "Phone Number",
                "sensitivity": "L2",
                "replacement": "(███) ███-████"
            },
            "email": {
                "pattern": r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b',
                "name": "Email Address",
                "sensitivity": "L2", 
                "replacement": "████████@██████.███"
            },
            "ip_address": {
                "pattern": r'\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b',
                "name": "IP Address",
                "sensitivity": "L3",
                "replacement": "███.███.███.███"
            },
            "date_of_birth": {
                "pattern": r'\b(?:0?[1-9]|1[0-2])[\/\-](?:0?[1-9]|[12][0-9]|3[01])[\/\-](?:19|20)\d{2}\b',
                "name": "Date of Birth",
                "sensitivity": "L1",
                "replacement": "██/██/████"
            },
            "address": {
                "pattern": r'\b\d+\s+[\w\s]+(?:street|st|avenue|ave|road|rd|drive|dr|lane|ln|boulevard|blvd|circle|cir|court|ct|place|pl)\b',
                "name": "Street Address",
                "sensitivity": "L2",
                "replacement": "███ █████ ██████"
            },
            "zip_code": {
                "pattern": r'\b\d{5}(?:-\d{4})?\b',
                "name": "ZIP Code",
                "sensitivity": "L2",
                "replacement": "█████"
            },
            "medical_record": {
                "pattern": r'\b(?:MRN|MR|Medical Record)[\s#:]*([A-Z0-9]{6,12})\b',
                "name": "Medical Record Number",
                "sensitivity": "L1",
                "replacement": "MRN: ████████"
            },
            "account_number": {
                "pattern": r'\b(?:Account|Acct)[\s#:]*([A-Z0-9]{8,15})\b',
                "name": "Account Number",
                "sensitivity": "L1",
                "replacement": "Account: ████████"
            },
            "patient_id": {
                "pattern": r'\b(?:Patient|PT)[\s#:]*([A-Z0-9]{6,12})\b',
                "name": "Patient ID",
                "sensitivity": "L1",
                "replacement": "Patient: ████████"
            },
            "investment_id": {
                "pattern": r'\b(?:Investment|Portfolio)[\s#:]*([A-Z0-9]{8,15})\b',
                "name": "Investment ID",
                "sensitivity": "L1",
                "replacement": "Investment: ████████"
            },
            "client_id": {
                "pattern": r'\b(?:Client|Customer)[\s#:]*([A-Z0-9]{6,12})\b',
                "name": "Client ID",
                "sensitivity": "L2",
                "replacement": "Client: ████████"
            },
            "service_ticket": {
                "pattern": r'\b(?:Ticket|TKT)[\s#:]*([A-Z0-9]{6,12})\b',
                "name": "Service Ticket",
                "sensitivity": "L3",
                "replacement": "Ticket: ████████"
            }
        }
    
    def detect_pii(self, text: str, sector: str = "general") -> List[Dict]:
        """Detect PII in text content"""
        detections = []
        
        # Get applicable patterns for sector
        applicable_patterns = self.redaction_patterns.copy()
        
        if sector in self.config["sectors"]:
            sector_config = self.config["sectors"][sector]
            if "additional_patterns" in sector_config:
                # Include additional patterns for this sector
                pass  # Patterns already included in initialization
        
        for pattern_name, pattern_config in applicable_patterns.items():
            pattern = pattern_config["pattern"]
            matches = re.finditer(pattern, text, re.IGNORECASE)
            
            for match in matches:
                detection = {
                    "type": pattern_name,
                    "name": pattern_config["name"],
                    "sensitivity": pattern_config["sensitivity"],
                    "start": match.start(),
                    "end": match.end(),
                    "original": match.group(),
                    "replacement": pattern_config["replacement"]
                }
                
                # Generate hash of original for audit trail
                if self.config["hash_original"]:
                    detection["hash"] = hashlib.sha256(
                        match.group().encode()
                    ).hexdigest()[:16]
                
                detections.append(detection)
        
        return detections
    
    def redact_text(self, text: str, detections: List[Dict]) -> Tuple[str, Dict]:
        """Redact detected PII from text"""
        redacted_text = text
        redaction_stats = {
            "total_redactions": len(detections),
            "by_type": {},
            "by_sensitivity": {"L1": 0, "L2": 0, "L3": 0}
        }
        
        # Sort detections by position (reverse order to maintain positions)
        detections_sorted = sorted(detections, key=lambda x: x["start"], reverse=True)
        
        for detection in detections_sorted:
            start, end = detection["start"], detection["end"]
            replacement = detection["replacement"]
            
            # Replace text
            redacted_text = redacted_text[:start] + replacement + redacted_text[end:]
            
            # Update statistics
            detection_type = detection["type"]
            sensitivity = detection["sensitivity"]
            
            redaction_stats["by_type"][detection_type] = (
                redaction_stats["by_type"].get(detection_type, 0) + 1
            )
            redaction_stats["by_sensitivity"][sensitivity] += 1
            
            # Log redaction
            if self.config["log_redactions"]:
                self.redaction_log.append({
                    "timestamp": datetime.now().isoformat(),
                    "type": detection_type,
                    "name": detection["name"],
                    "sensitivity": sensitivity,
                    "hash": detection.get("hash", ""),
                    "position": f"{start}-{end}"
                })
        
        return redacted_text, redaction_stats
    
    def process_csv(self, input_path: str, output_path: str, sector: str = "general") -> Dict:
        """Process CSV file with PII redaction"""
        logger.info(f"Processing CSV file: {input_path}")
        
        df = pd.read_csv(input_path)
        total_stats = {
            "rows_processed": len(df),
            "columns_processed": len(df.columns),
            "total_redactions": 0,
            "by_type": {},
            "by_sensitivity": {"L1": 0, "L2": 0, "L3": 0}
        }
        
        for column in df.columns:
            logger.info(f"Processing column: {column}")
            
            for idx, value in df[column].items():
                if pd.isna(value):
                    continue
                    
                text_value = str(value)
                detections = self.detect_pii(text_value, sector)
                
                if detections:
                    redacted_text, stats = self.redact_text(text_value, detections)
                    df.at[idx, column] = redacted_text
                    
                    # Aggregate statistics
                    total_stats["total_redactions"] += stats["total_redactions"]
                    for k, v in stats["by_type"].items():
                        total_stats["by_type"][k] = total_stats["by_type"].get(k, 0) + v
                    for k, v in stats["by_sensitivity"].items():
                        total_stats["by_sensitivity"][k] += v
        
        # Save redacted CSV
        df.to_csv(output_path, index=False)
        logger.info(f"Redacted CSV saved to: {output_path}")
        
        return total_stats
    
    def process_json(self, input_path: str, output_path: str, sector: str = "general") -> Dict:
        """Process JSON file with PII redaction"""
        logger.info(f"Processing JSON file: {input_path}")
        
        with open(input_path, 'r') as f:
            data = json.load(f)
        
        total_stats = {
            "total_redactions": 0,
            "by_type": {},
            "by_sensitivity": {"L1": 0, "L2": 0, "L3": 0}
        }
        
        def redact_recursive(obj):
            """Recursively redact PII in JSON structure"""
            if isinstance(obj, dict):
                for key, value in obj.items():
                    obj[key] = redact_recursive(value)
            elif isinstance(obj, list):
                for i, item in enumerate(obj):
                    obj[i] = redact_recursive(item)
            elif isinstance(obj, str):
                detections = self.detect_pii(obj, sector)
                if detections:
                    redacted_text, stats = self.redact_text(obj, detections)
                    
                    # Aggregate statistics
                    total_stats["total_redactions"] += stats["total_redactions"]
                    for k, v in stats["by_type"].items():
                        total_stats["by_type"][k] = total_stats["by_type"].get(k, 0) + v
                    for k, v in stats["by_sensitivity"].items():
                        total_stats["by_sensitivity"][k] += v
                    
                    return redacted_text
            return obj
        
        redacted_data = redact_recursive(data)
        
        # Save redacted JSON
        with open(output_path, 'w') as f:
            json.dump(redacted_data, f, indent=2)
        
        logger.info(f"Redacted JSON saved to: {output_path}")
        return total_stats
    
    def process_text(self, input_path: str, output_path: str, sector: str = "general") -> Dict:
        """Process plain text file with PII redaction"""
        logger.info(f"Processing text file: {input_path}")
        
        with open(input_path, 'r', encoding='utf-8') as f:
            text = f.read()
        
        detections = self.detect_pii(text, sector)
        redacted_text, stats = self.redact_text(text, detections)
        
        # Save redacted text
        with open(output_path, 'w', encoding='utf-8') as f:
            f.write(redacted_text)
        
        logger.info(f"Redacted text saved to: {output_path}")
        return stats
    
    def generate_redaction_report(self, output_path: str, stats: Dict) -> None:
        """Generate detailed redaction report"""
        report = {
            "report_metadata": {
                "generated_at": datetime.now().isoformat(),
                "redactor_version": "1.0",
                "total_files_processed": 1
            },
            "redaction_statistics": stats,
            "redaction_log": self.redaction_log,
            "recommendations": self._generate_recommendations(stats)
        }
        
        with open(output_path, 'w') as f:
            json.dump(report, f, indent=2)
        
        logger.info(f"Redaction report saved to: {output_path}")
    
    def _generate_recommendations(self, stats: Dict) -> List[str]:
        """Generate security recommendations based on redaction results"""
        recommendations = []
        
        if stats["by_sensitivity"]["L1"] > 0:
            recommendations.append(
                "🔴 L1 Restricted data detected: Implement strongest encryption, "
                "access controls, and audit logging"
            )
        
        if stats["by_sensitivity"]["L2"] > 0:
            recommendations.append(
                "🟡 L2 Confidential data detected: Use encryption and "
                "role-based access controls"
            )
        
        if stats["total_redactions"] > 100:
            recommendations.append(
                "High volume of PII detected: Consider automated redaction "
                "pipeline for future data processing"
            )
        
        if "email" in stats["by_type"] and stats["by_type"]["email"] > 10:
            recommendations.append(
                "Multiple email addresses detected: Review email handling "
                "policies for AI training data"
            )
        
        recommendations.append(
            "Regular PII audits recommended for all AI training datasets"
        )
        
        return recommendations

def main():
    """Main CLI interface"""
    parser = argparse.ArgumentParser(
        description="🔒 AI Content Redaction Tool",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Redact CSV file for healthcare
  python redact-ai-content.py -i patient-data.csv -o redacted-data.csv -s clinic

  # Redact JSON with detailed report
  python redact-ai-content.py -i training-data.json -o clean-data.json -r report.json

  # Process text file for family office
  python redact-ai-content.py -i client-notes.txt -o redacted-notes.txt -s family-office
        """
    )
    
    parser.add_argument(
        "-i", "--input",
        required=True,
        help="Input file path"
    )
    
    parser.add_argument(
        "-o", "--output", 
        required=True,
        help="Output file path for redacted content"
    )
    
    parser.add_argument(
        "-s", "--sector",
        choices=["clinic", "family-office", "msp", "general"],
        default="general",
        help="Sector-specific redaction rules"
    )
    
    parser.add_argument(
        "-f", "--format",
        choices=["auto", "csv", "json", "text"],
        default="auto",
        help="Input file format (auto-detect if not specified)"
    )
    
    parser.add_argument(
        "-r", "--report",
        help="Path for detailed redaction report (JSON)"
    )
    
    parser.add_argument(
        "-c", "--config",
        help="Path to custom configuration file"
    )
    
    parser.add_argument(
        "-v", "--verbose",
        action="store_true",
        help="Verbose output"
    )
    
    args = parser.parse_args()
    
    if args.verbose:
        logging.getLogger().setLevel(logging.DEBUG)
    
    # Initialize redactor
    redactor = AIContentRedactor(args.config)
    
    # Auto-detect format if needed
    file_format = args.format
    if file_format == "auto":
        extension = Path(args.input).suffix.lower()
        format_map = {
            ".csv": "csv",
            ".json": "json", 
            ".txt": "text",
            ".md": "text"
        }
        file_format = format_map.get(extension, "text")
    
    # Process file based on format
    try:
        if file_format == "csv":
            stats = redactor.process_csv(args.input, args.output, args.sector)
        elif file_format == "json":
            stats = redactor.process_json(args.input, args.output, args.sector)
        elif file_format == "text":
            stats = redactor.process_text(args.input, args.output, args.sector)
        else:
            logger.error(f"Unsupported file format: {file_format}")
            sys.exit(1)
        
        # Print summary
        print(f"\n📊 Redaction Summary")
        print(f"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print(f"Total redactions: {stats['total_redactions']}")
        print(f"🔴 L1 Restricted: {stats['by_sensitivity']['L1']}")
        print(f"🟡 L2 Confidential: {stats['by_sensitivity']['L2']}")
        print(f"🟢 L3 Internal: {stats['by_sensitivity']['L3']}")
        
        if stats["by_type"]:
            print(f"\nRedactions by type:")
            for pii_type, count in stats["by_type"].items():
                print(f"  {pii_type}: {count}")
        
        # Generate report if requested
        if args.report:
            redactor.generate_redaction_report(args.report, stats)
        
        print(f"\n✅ Redaction completed successfully")
        print(f"📄 Redacted file: {args.output}")
        if args.report:
            print(f"📋 Report: {args.report}")
            
    except Exception as e:
        logger.error(f"Error processing file: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()

#!/bin/bash
echo "Validating EDR agent..."
if pgrep edr_agent; then
    echo "✅ Agent active"
else
    echo "⚠️ Agent not found. Trigger fallback."
fi

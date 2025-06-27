#!/bin/bash

# test-startup-time.sh - Test MARVIM Neovim startup performance
# Usage: ./test-startup-time.sh [iterations] [output_format]
#   iterations: number of test runs (default: 10)
#   output_format: simple|detailed|csv (default: detailed)

set -euo pipefail

# Configuration
ITERATIONS=${1:-10}
OUTPUT_FORMAT=${2:-detailed}
NVIM_CMD="nvim"
TEST_FILE="test_startup.lua"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if nvim is available
if ! command -v $NVIM_CMD &> /dev/null; then
    echo -e "${RED}Error: nvim not found in PATH${NC}" >&2
    exit 1
fi

# Check if we're in the MARVIM directory
if [[ ! -f "init.lua" || ! -d "lua/config" ]]; then
    echo -e "${RED}Error: Please run this script from the MARVIM root directory${NC}" >&2
    exit 1
fi

# Remove any existing test file
rm -f "$TEST_FILE"

echo -e "${BLUE}Testing MARVIM startup time...${NC}"
echo -e "${YELLOW}Iterations: $ITERATIONS${NC}"
echo

# Arrays to store results
declare -a times
declare -a plugin_counts
declare -a load_times

# Function to run startup test  
run_test() {
    local log_file="/tmp/startup_simple_$$.log"
    if $NVIM_CMD --headless --startuptime "$log_file" +quit >/dev/null 2>&1; then
        if [[ -f "$log_file" ]]; then
            # Get the line with "--- NVIM STARTED ---" and extract time
            local time=$(grep "NVIM STARTED" "$log_file" | awk '{print $1}')
            rm -f "$log_file"
            echo "${time:-0}"
        else
            echo "0"
        fi
    else
        rm -f "$log_file"
        echo "0"
    fi
}

# Function to get plugin count
get_plugin_count() {
    local output=$($NVIM_CMD --headless -c "lua print('PLUGIN_COUNT:' .. #require('lazy').plugins())" +quit 2>&1)
    local count=$(echo "$output" | grep "PLUGIN_COUNT:" | sed 's/PLUGIN_COUNT://')
    if [[ "$count" =~ ^[0-9]+$ ]]; then
        echo "$count"
    else
        echo "Unknown"
    fi
}

# Function to get detailed timing with plugin breakdown
get_detailed_timing() {
    local log_file="/tmp/startup_$$.log"
    if $NVIM_CMD --headless --startuptime "$log_file" +quit >/dev/null 2>&1; then
        if [[ -f "$log_file" ]]; then
            local total_time
            total_time=$(grep "NVIM STARTED" "$log_file" | awk '{print $1}')
            local plugin_time
            plugin_time=$(grep -E "require.*lazy" "$log_file" | awk '{sum += $2} END {print sum+0}')
            echo "${total_time:-0} ${plugin_time:-0}"
            
            # Extract plugin load times for detailed output
            if [[ "$OUTPUT_FORMAT" == "detailed" ]]; then
                echo "PLUGIN_BREAKDOWN:" >> "$log_file.breakdown"
                grep -E "require.*config\.plugins\.|require.*lazy\." "$log_file" | \
                    awk '{printf "%.1fms: %s\n", $2, $NF}' | \
                    sort -nr >> "$log_file.breakdown"
            fi
            
            rm -f "$log_file"
        else
            echo "0 0"
        fi
    else
        rm -f "$log_file"
        echo "0 0"
    fi
}

# Get plugin count once
PLUGIN_COUNT=$(get_plugin_count)

# Run tests
echo -e "${YELLOW}Running $ITERATIONS tests...${NC}"
for i in $(seq 1 $ITERATIONS); do
    if [[ "$OUTPUT_FORMAT" == "detailed" ]]; then
        echo -n "Test $i/$ITERATIONS... "
    fi
    
    if [[ "$OUTPUT_FORMAT" == "detailed" ]]; then
        timing=$(get_detailed_timing)
        total_time=$(echo "$timing" | awk '{print $1}')
        plugin_time=$(echo "$timing" | awk '{print $2}')
        times+=("$total_time")
        load_times+=("$plugin_time")
        echo -e "${GREEN}${total_time}ms${NC} (plugins: ${plugin_time}ms)"
    else
        time=$(run_test)
        times+=("$time")
        if [[ "$OUTPUT_FORMAT" == "simple" ]]; then
            echo "Test $i: ${time}ms"
        fi
    fi
done

# Calculate statistics
calculate_stats() {
    local arr=("$@")
    local sum=0
    local min=${arr[0]}
    local max=${arr[0]}
    
    for time in "${arr[@]}"; do
        sum=$(echo "$sum + $time" | bc -l)
        if (( $(echo "$time < $min" | bc -l) )); then
            min=$time
        fi
        if (( $(echo "$time > $max" | bc -l) )); then
            max=$time
        fi
    done
    
    local avg=$(echo "scale=2; $sum / ${#arr[@]}" | bc -l)
    echo "$avg $min $max"
}

# Calculate results
total_stats=$(calculate_stats "${times[@]}")
avg_total=$(echo "$total_stats" | awk '{print $1}')
min_total=$(echo "$total_stats" | awk '{print $2}')
max_total=$(echo "$total_stats" | awk '{print $3}')

if [[ "$OUTPUT_FORMAT" == "detailed" && ${#load_times[@]} -gt 0 ]]; then
    plugin_stats=$(calculate_stats "${load_times[@]}")
    avg_plugin=$(echo "$plugin_stats" | awk '{print $1}')
    min_plugin=$(echo "$plugin_stats" | awk '{print $2}')
    max_plugin=$(echo "$plugin_stats" | awk '{print $3}')
fi

# Output results
echo
case "$OUTPUT_FORMAT" in
    "csv")
        echo "metric,average,min,max,plugin_count"
        echo "total_time,$avg_total,$min_total,$max_total,$PLUGIN_COUNT"
        if [[ ${#load_times[@]} -gt 0 ]]; then
            echo "plugin_time,$avg_plugin,$min_plugin,$max_plugin,$PLUGIN_COUNT"
        fi
        ;;
    "simple")
        printf "${GREEN}Average: %.1fms${NC}\n" "$avg_total"
        printf "${BLUE}Range: %.1fms - %.1fms${NC}\n" "$min_total" "$max_total"
        ;;
    "detailed")
        echo -e "${BLUE}=== MARVIM Startup Performance Report ===${NC}"
        echo -e "${YELLOW}Configuration:${NC}"
        echo "  • Plugins loaded: $PLUGIN_COUNT"
        echo "  • Test iterations: $ITERATIONS"
        echo
        echo -e "${YELLOW}Total Startup Time:${NC}"
        printf "  • Average: ${GREEN}%.1fms${NC}\n" "$avg_total"
        printf "  • Fastest: ${GREEN}%.1fms${NC}\n" "$min_total"
        printf "  • Slowest: ${RED}%.1fms${NC}\n" "$max_total"
        
        if [[ ${#load_times[@]} -gt 0 ]]; then
            echo
            echo -e "${YELLOW}Plugin Load Time:${NC}"
            printf "  • Average: ${GREEN}%.1fms${NC}\n" "$avg_plugin"
            printf "  • Fastest: ${GREEN}%.1fms${NC}\n" "$min_plugin"
            printf "  • Slowest: ${RED}%.1fms${NC}\n" "$max_plugin"
            
            # Calculate percentage (avoid division by zero)
            if (( $(echo "$avg_total > 0" | bc -l) )); then
                plugin_percentage=$(echo "scale=1; $avg_plugin / $avg_total * 100" | bc -l)
                printf "  • Plugin overhead: ${YELLOW}%.1f%%${NC}\n" "$plugin_percentage"
            else
                echo "  • Plugin overhead: ${YELLOW}N/A${NC}"
            fi
        fi
        
        # Show plugin breakdown if available
        if [[ -f "/tmp/startup_$$.log.breakdown" ]]; then
            echo
            echo -e "${YELLOW}Plugin Load Times (Top 10):${NC}"
            head -10 "/tmp/startup_$$.log.breakdown" | grep -v "PLUGIN_BREAKDOWN:" | sed 's/^/  • /'
            rm -f "/tmp/startup_$$.log.breakdown"
        fi
        ;;
esac

# Cleanup any remaining temp files
rm -f "$TEST_FILE" /tmp/startup_*.log

echo
echo -e "${BLUE}Test completed successfully!${NC}"
#!/bin/bash

# XYZZY:
# MjAyNS0wMS0xMiAwMzowMAo=
# MjAyNS0wMS0xMyAxNzo0MAo=
# MjAyNS0wMS0xNSAwMzo1Mwo=
# MjAyNS0wMS0xNyAxMTo0MAo=
# MjAyNS0wMS0xNyAyMjowMAo=
# MjAyNS0wMS0xOCAwMTowMAo=
# MjAyNS0wMS0yMCAyMzowMAo=
# MjAyNS0wMS0yMyAwMTo0Mgo=
# MjAyNS0wMS0yNSA4OjMwCg==
# MjAyNS0wMS0yOCA5OjU2Cg==
# MjAyNS0wMS0yOSA0OjIwCg==
# MjAyNS0wMS0zMSAxMjoxNwo=
# MjAyNS0wMi0wMiAyOjI0Cg==
# MjAyNS0wMi0wMyAxMjo1Nwo=
# MjAyNS0wMi0wNSA2OjM1Cg==
# MjAyNS0wMi0wNyAwOjAK
# MjAyNS0wMi0wNyA1OjAK
# MjAyNS0wMi0wOSA4OjE3Cg==
# END

# 编码时间戳
encode_timestamp() {
    echo "$1" | base64
}

# 解码时间戳
decode_timestamp() {
    echo "$1" | base64 --decode
}

# 获取时间戳列表
get_timestamps() {
    sed -n '/^# XYZZY:/,/^# END/ p' "$0" | grep -v '^# XYZZY:' | grep -v '^# END'
}

# 注册时刻
register() {
    local timestamp
    if [[ -n "$1" ]]; then
        # 检查传入的时间格式是否正确
        if ! date -d "$1" &>/dev/null; then
            echo "Error: Invalid timestamp format. Please use 'YYYY-MM-DD HH:MM:SS'."
            return 1
        fi
        timestamp="$1"
    else
        # 如果没有传入时间，则使用当前时间
        timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    fi

    # 将时间戳编码后添加到脚本中
    encoded_timestamp=$(encode_timestamp "$timestamp")
    sed -i --follow-symlinks "/^# END/ i # $encoded_timestamp" "$0"
    echo "Registered: $timestamp"
}

# 查询时刻列表中的时间差
query() {
    local prev_time=""
    get_timestamps | while IFS= read -r line; do
        line=$(echo "$line" | sed 's/^# //')  # 去掉注释符号
        timestamp=$(decode_timestamp "$line")
        if [[ -n "$prev_time" ]]; then
            local prev_epoch
            local current_epoch
            local diff_hours

            # 将时间转换为 epoch 时间
            prev_epoch=$(date -d "$prev_time" +%s)
            current_epoch=$(date -d "$timestamp" +%s)

            # 计算时间差（小时）
            diff_hours=$(echo "scale=2; ($current_epoch - $prev_epoch) / 3600" | bc)
            printf "%s—%s: %6.2f hours\n" "$prev_time" "$timestamp" "$diff_hours"
        fi
        prev_time="$timestamp"
    done
}

# 默认行为：显示当前时间与最后一个时刻的时间差
default_action() {
    local last_time
    last_time=$(get_timestamps | tail -n 1 | sed 's/^# //')
    last_time=$(decode_timestamp "$last_time")

    if [[ -z "$last_time" ]]; then
        echo "No timestamps registered yet."
        return
    fi

    local last_epoch
    local current_epoch
    local diff_hours

    # 将时间转换为 epoch 时间
    last_epoch=$(date -d "$last_time" +%s)
    current_epoch=$(date +%s)

    # 计算时间差（小时）
    diff_hours=$(echo "scale=2; ($current_epoch - $last_epoch) / 3600" | bc)
    printf "%s—now: %6.2f hours\n" "$last_time" "$diff_hours"
}

# 主逻辑
case "$1" in
    register)
        register "$2"
        ;;
    query)
        query
        ;;
    *)
        default_action
        ;;
esac

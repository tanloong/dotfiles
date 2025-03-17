#!/usr/bin/env python3

import argparse
import os
from collections import defaultdict
from datetime import datetime, timedelta
from pathlib import Path
from unicodedata import east_asian_width as _east_asian_width

DATABASE = Path("~/.config/span.db").expanduser()


# 数据库初始化
def init_db():
    import sqlite3

    conn = sqlite3.connect(DATABASE)
    c = conn.cursor()
    c.execute("""CREATE TABLE IF NOT EXISTS records
                 (id INTEGER PRIMARY KEY AUTOINCREMENT,
                  timestamp DATETIME,
                  note TEXT)""")
    c.execute("""CREATE TABLE IF NOT EXISTS config
                 (key TEXT PRIMARY KEY,
                  value TEXT)""")
    conn.commit()
    conn.close()


# 记录新事件（支持手动指定时间）
def add_record(args):
    import sqlite3

    conn = sqlite3.connect(DATABASE)
    c = conn.cursor()

    # 时间处理逻辑
    if args.time:
        try:
            # 支持多种时间格式输入
            time_formats = ["%Y-%m-%d %H:%M", "%Y/%m/%d %H:%M", "%Y%m%d%H%M"]
            for fmt in time_formats:
                try:
                    record_time = datetime.strptime(args.time, fmt)
                    break
                except ValueError:
                    continue
            else:
                raise ValueError("无法识别的时间格式")
        except ValueError as e:
            print(f"时间解析错误: {e}")
            print("请使用以下格式之一：")
            print("1. 2023-10-05 14:30")
            print("2. 2023/10/05 14:30")
            print("3. 202310051430")
            return
    else:
        record_time = datetime.now()

    # 加密敏感数据
    encrypted_data = (args.note,)

    # 插入数据库
    try:
        c.execute(
            """INSERT INTO records 
                    (timestamp, note)
                    VALUES (?, ?)""",
            (record_time.isoformat(), *encrypted_data),
        )
        conn.commit()
        print(f"成功记录 {record_time.strftime('%Y-%m-%d %H:%M')} 的事件")
    except Exception as e:
        print(f"记录失败: {str(e)}")
    finally:
        conn.close()


# 生成周报
# 生成全报
def viz_bar():
    import sqlite3

    import matplotlib.pyplot as plt

    plt.rcParams["font.sans-serif"] = ["SimSun"]
    plt.rcParams["axes.unicode_minus"] = False

    conn = sqlite3.connect(DATABASE)
    c = conn.cursor()

    c.execute("""SELECT timestamp FROM records WHERE timestamp""")
    records = c.fetchall()

    # 分析时间段分布
    time_dist = defaultdict(int)
    for r in records:
        hour = datetime.fromisoformat(r[0]).hour
        time_dist[f"{hour:02}:00-{hour + 1:02}:00"] += 1
    time_dist = dict(sorted(time_dist.items(), key=lambda item: item[0]))

    # 可视化
    plt.figure(figsize=(10, 6))
    plt.bar(time_dist.keys(), time_dist.values())
    plt.title("历史时段分布")
    plt.xlabel("时段")
    plt.ylabel("次数")
    plt.xticks(rotation=30)
    plt.tight_layout()
    plt.show()
    # plt.savefig("viz.png")
    # print("已生成历史时段分布: viz.png")


def viz_boxplot():
    import sqlite3

    import matplotlib.pyplot as plt

    plt.rcParams["font.sans-serif"] = ["SimSun"]
    plt.rcParams["axes.unicode_minus"] = False

    conn = sqlite3.connect(DATABASE)
    c = conn.cursor()

    c.execute("""SELECT timestamp FROM records ORDER BY timestamp DESC""")
    records = [datetime.fromisoformat(row[0]) for row in c.fetchall()]

    # 计算时间间隔
    intervals = []
    hour = timedelta(hours=1)
    for i in range(1, len(records)):
        delta = records[i - 1] - records[i]
        intervals.append(delta / hour)
    plt.boxplot(intervals, showfliers=False)
    # plt.yticks(range(0, int(max(intervals)), 2))
    plt.grid(True, axis='y', linestyle='--', alpha=0.7)

    plt.show()


def viz(args):
    if args.bar:
        viz_bar()
    elif args.boxplot:
        viz_boxplot()


# 频率统计
def show_statistics():
    import sqlite3

    conn = sqlite3.connect(DATABASE)
    c = conn.cursor()

    # 本月数据
    c.execute(
        """SELECT COUNT(*) FROM records
                WHERE strftime('%Y-%m', timestamp) = ?""",
        (datetime.now().strftime("%Y-%m"),),
    )
    current_month = c.fetchone()[0]

    # 上月数据
    last_month = (datetime.now() - timedelta(days=30)).strftime("%Y-%m")
    c.execute(
        """SELECT COUNT(*) FROM records
                WHERE strftime('%Y-%m', timestamp) = ?""",
        (last_month,),
    )
    prev_month = c.fetchone()[0]

    print(f"\n本月次数: {current_month}")
    print(f"上月次数: {prev_month}")
    print(f"变化趋势: {'↑' if current_month > prev_month else '↓'} {abs(current_month - prev_month)}次")


# 添加状态查询功能
def show_rank():
    import sqlite3

    conn = sqlite3.connect(DATABASE)
    c = conn.cursor()

    try:
        # 获取所有记录的时间戳
        c.execute("""SELECT timestamp FROM records ORDER BY timestamp DESC""")
        records = [datetime.fromisoformat(row[0]) for row in c.fetchall()]

        if not records:
            print("暂无记录")
            return

        # 计算时间间隔
        intervals = []
        for i in range(1, len(records)):
            delta = records[i - 1] - records[i]
            intervals.append(delta.total_seconds())

        # 当前间隔
        current_interval = datetime.now() - records[0]
        current_seconds = current_interval.total_seconds()

        # 当前间隔排名
        sorted_intervals = sorted(intervals, reverse=True)
        rank = next(
            (i + 1 for i, v in enumerate(sorted_intervals) if current_seconds > v), len(sorted_intervals) + 1
        )

        # 统计信息
        avg_interval = sum(intervals) / len(intervals) if intervals else 0
        max_interval = max(intervals) if intervals else 0
        next_interval = sorted_intervals[rank - 2]

        # 格式化输出
        def format_time(seconds):
            hours, remainder = divmod(seconds, 3600)
            minutes, seconds = divmod(remainder, 60)
            return f"{int(hours):02}小时{int(minutes):02}分钟"

        print(f"{format_time(current_seconds)} ({rank}/{len(intervals) + 1})")

        def get_east_asin_width_count(s: str) -> int:
            ret = 0
            for c in s:
                if _east_asian_width(c) in "FWA":
                    ret += 2
                else:
                    ret += 1
            return ret

        def print_bar(n1, n2, title):
            progress = min(n1 / n2, 1.0)
            first_part = f"{title} {progress * 100:.1f}%"
            bar_length = min(os.get_terminal_size().columns - get_east_asin_width_count(first_part) - 3, 30)
            filled = int(progress * bar_length)
            second_part = f"[{'#' * filled}{'-' * (bar_length - filled)}]"
            print(f"{first_part} {second_part}")

        # 进度条显示
        print_bar(current_seconds, next_interval, f"距下一间隔 ({format_time(next_interval)})")
        if current_seconds < avg_interval:
            print_bar(current_seconds, avg_interval, f"距平均间隔 ({format_time(avg_interval)})")
        if current_seconds < max_interval:
            print_bar(current_seconds, max_interval, f"距最长间隔 ({format_time(max_interval)})")
    except Exception as e:
        print(f"查询失败: {str(e)}")
    finally:
        conn.close()


def delete_records():
    import sqlite3

    conn = sqlite3.connect(DATABASE)
    c = conn.cursor()

    try:
        # 打印所有记录
        c.execute("""SELECT id, timestamp FROM records ORDER BY timestamp""")
        records = c.fetchall()

        if not records:
            print("暂无记录")
            return

        print("\n当前记录列表：")
        print("{:<5} {:<20}".format("ID", "时间"))
        for r in records:
            print("{:<5} {:<20}".format(r[0], datetime.fromisoformat(r[1]).strftime("%Y-%m-%d %H:%M")))

        ids = input("要删除的ID范围，例如：\n1-3 删除ID 1到3\n1-3,5 删除ID 1到3和5\n")
        # 解析删除范围
        ids_to_delete = set()
        for part in ids.split():
            part = part.strip()
            if "-" in part:
                start, end = map(int, part.split("-"))
                ids_to_delete.update(range(start, end + 1))
            else:
                ids_to_delete.add(int(part))

        # 确认删除
        confirm = input(f"\n确定要删除以下ID的记录吗？ {sorted(ids_to_delete)} [y/N]: ")
        if confirm.lower() != "y":
            print("取消删除")
            return

        # 执行删除
        placeholders = ",".join("?" * len(ids_to_delete))
        c.execute(f"DELETE FROM records WHERE id IN ({placeholders})", tuple(ids_to_delete))
        conn.commit()

        print(f"成功删除 {c.rowcount} 条记录")

    except ValueError:
        print("错误：请输入有效的ID范围，如 '1-3,5'")
    except Exception as e:
        print(f"删除失败: {str(e)}")
    finally:
        conn.close()


# 命令行界面
def main():
    init_db()

    parser = argparse.ArgumentParser(description="习惯追踪管理器")
    subparsers = parser.add_subparsers()

    add_parser = subparsers.add_parser("add")
    add_parser.add_argument(
        "-t",
        "--time",
        help="指定事件时间（支持格式：2023-10-05 14:30 | 2023/10/05 14:30 | 202310051430）",
    )
    add_parser.add_argument("-n", "--note", default="", help="附加备注")
    add_parser.set_defaults(func=add_record)

    # 可视化命令
    viz_parser = subparsers.add_parser("viz", help="可视化")
    group = viz_parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--bar", action="store_true", help="条形图")
    group.add_argument("--boxplot", action="store_true", help="直方图")
    viz_parser.set_defaults(func=lambda _: viz(args))

    # 查看统计命令
    stat_parser = subparsers.add_parser("stats", help="月度统计")
    stat_parser.set_defaults(func=lambda _: show_statistics())

    # 在命令行解析中添加rank命令
    rank_parser = subparsers.add_parser("rank", help="查看排名")
    rank_parser.set_defaults(func=lambda _: show_rank())

    # 在命令行解析中添加delete命令
    delete_parser = subparsers.add_parser("delete", help="删除记录")
    delete_parser.set_defaults(func=lambda _: delete_records())

    args = parser.parse_args()
    if hasattr(args, "func"):
        args.func(args)
    else:
        parser.print_help()


if __name__ == "__main__":
    main()

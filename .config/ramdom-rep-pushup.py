import random
import time
import sys
import os
import math
from datetime import datetime

try:
    import curses
except ImportError:
    print("curses module not available.")
    sys.exit(1)


def draw_bar(stdscr, y, x, value, max_value, width, color_pair):
    filled = int((value / max_value) * width)
    bar = "█" * filled + "░" * (width - filled)
    stdscr.addstr(y, x, bar, curses.color_pair(color_pair))


def draw_border(stdscr, y, x, h, w, color_pair):
    stdscr.addstr(y, x, "╔" + "═" * (w - 2) + "╗", curses.color_pair(color_pair))
    for i in range(1, h - 1):
        stdscr.addstr(y + i, x, "║", curses.color_pair(color_pair))
        stdscr.addstr(y + i, x + w - 1, "║", curses.color_pair(color_pair))
    stdscr.addstr(y + h - 1, x, "╚" + "═" * (w - 2) + "╝", curses.color_pair(color_pair))


def draw_section_header(stdscr, y, x, title, width, color_pair):
    padding = (width - len(title) - 2) // 2
    left = "═" * padding
    right = "═" * (width - len(title) - 2 - padding)
    stdscr.addstr(y, x, f"╠{left}[ ", curses.color_pair(color_pair))
    stdscr.addstr(y, x + len(left) + 2, title, curses.color_pair(5) | curses.A_BOLD)
    stdscr.addstr(y, x + len(left) + 2 + len(title), f" ]{right}╣", curses.color_pair(color_pair))


def get_bar_color(pct):
    if pct < 0.4:
        return 2
    elif pct < 0.75:
        return 3
    else:
        return 4


def main(stdscr):
    curses.curs_set(0)
    stdscr.nodelay(True)
    curses.start_color()
    curses.use_default_colors()

    curses.init_pair(1, curses.COLOR_CYAN, -1)
    curses.init_pair(2, curses.COLOR_GREEN, -1)
    curses.init_pair(3, curses.COLOR_YELLOW, -1)
    curses.init_pair(4, curses.COLOR_RED, -1)
    curses.init_pair(5, curses.COLOR_WHITE, -1)
    curses.init_pair(6, curses.COLOR_MAGENTA, -1)
    curses.init_pair(7, curses.COLOR_BLACK, curses.COLOR_CYAN)
    curses.init_pair(8, curses.COLOR_BLUE, -1)

    MIN_REPS = 100
    MAX_REPS = 600
    target = random.randint(MIN_REPS, MAX_REPS)

    sets_data = []
    num_sets = random.randint(3, 6)
    remaining = target
    for i in range(num_sets):
        if i == num_sets - 1:
            sets_data.append(remaining)
        else:
            chunk = random.randint(
                max(10, remaining // (num_sets - i) - 20),
                min(remaining - (num_sets - i - 1) * 10, remaining // (num_sets - i) + 20)
            )
            sets_data.append(chunk)
            remaining -= chunk

    history = []
    tick = 0
    phase = "COUNTDOWN"
    countdown = 3
    current_rep = 0
    current_set = 0
    set_progress = 0
    animation_frame = 0
    last_tick_time = time.time()
    done = False
    elapsed_start = None

    spinner_chars = ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"]
    muscle_frames = ["💪", "🏋️", "💥", "⚡", "🔥"]

    while True:
        key = stdscr.getch()
        if key == ord('q') or key == ord('Q'):
            break

        now = time.time()
        dt = now - last_tick_time

        if dt >= 0.1:
            last_tick_time = now
            tick += 1
            animation_frame = (animation_frame + 1) % len(spinner_chars)

            if phase == "COUNTDOWN":
                if tick % 10 == 0:
                    countdown -= 1
                    if countdown <= 0:
                        phase = "RUNNING"
                        elapsed_start = time.time()

            elif phase == "RUNNING" and not done:
                if tick % 3 == 0 and current_set < num_sets:
                    set_progress += 1
                    current_rep += 1
                    if set_progress >= sets_data[current_set]:
                        history.append(sets_data[current_set])
                        current_set += 1
                        set_progress = 0
                    if current_rep >= target:
                        done = True
                        phase = "DONE"

        height, width = stdscr.getmaxyx()
        stdscr.erase()

        panel_w = min(width - 2, 80)
        panel_x = (width - panel_w) // 2
        panel_h = min(height - 2, 36)
        panel_y = (height - panel_h) // 2

        draw_border(stdscr, panel_y, panel_x, panel_h, panel_w, 1)

        title_text = "  PUSHUP TRACKER PRO  "
        title_x = panel_x + (panel_w - len(title_text)) // 2
        try:
            stdscr.addstr(panel_y, title_x, title_text, curses.color_pair(7) | curses.A_BOLD)
        except curses.error:
            pass

        ver_text = "v1.0.0"
        try:
            stdscr.addstr(panel_y, panel_x + panel_w - len(ver_text) - 2, ver_text, curses.color_pair(8))
        except curses.error:
            pass

        row = panel_y + 1

        spinner = spinner_chars[animation_frame]
        muscle = muscle_frames[(tick // 5) % len(muscle_frames)]
        status_map = {
            "COUNTDOWN": (f" {spinner} STARTING IN {countdown}...", 3),
            "RUNNING": (f" {muscle} WORKOUT IN PROGRESS", 2),
            "DONE": (f" ✓ WORKOUT COMPLETE!", 2),
        }
        status_text, status_color = status_map[phase]
        try:
            stdscr.addstr(row, panel_x + 2, status_text.ljust(panel_w - 4), curses.color_pair(status_color) | curses.A_BOLD)
        except curses.error:
            pass
        row += 1

        try:
            now_str = datetime.now().strftime("%Y-%m-%d  %H:%M:%S")
            if elapsed_start and not done:
                elapsed = int(time.time() - elapsed_start)
                m, s = divmod(elapsed, 60)
                time_str = f"Elapsed: {m:02d}:{s:02d}   {now_str}"
            elif done and elapsed_start:
                elapsed = int(time.time() - elapsed_start)
                m, s = divmod(elapsed, 60)
                time_str = f"Total Time: {m:02d}:{s:02d}   {now_str}"
            else:
                time_str = f"Time: {now_str}"
            stdscr.addstr(row, panel_x + 2, time_str[:panel_w - 4], curses.color_pair(8))
        except curses.error:
            pass
        row += 1

        try:
            draw_section_header(stdscr, row, panel_x, "OVERALL PROGRESS", panel_w - 1, 1)
        except curses.error:
            pass
        row += 1

        pct = current_rep / target if target > 0 else 0
        bar_w = panel_w - 20
        bar_color = get_bar_color(pct)
        try:
            stdscr.addstr(row, panel_x + 2, f"Total Reps  ", curses.color_pair(5))
            draw_bar(stdscr, row, panel_x + 14, current_rep, target, bar_w, bar_color)
            stdscr.addstr(row, panel_x + 14 + bar_w + 1, f"{current_rep:>4}/{target}", curses.color_pair(5) | curses.A_BOLD)
        except curses.error:
            pass
        row += 1

        try:
            pct_val = pct * 100
            pct_bar_w = panel_w - 20
            filled_pct = int(pct * pct_bar_w)
            pct_bar = "▓" * filled_pct + "░" * (pct_bar_w - filled_pct)
            stdscr.addstr(row, panel_x + 2, f"Completion  ", curses.color_pair(5))
            stdscr.addstr(row, panel_x + 14, pct_bar, curses.color_pair(bar_color))
            stdscr.addstr(row, panel_x + 14 + pct_bar_w + 1, f"{pct_val:>5.1f}%", curses.color_pair(bar_color) | curses.A_BOLD)
        except curses.error:
            pass
        row += 1

        try:
            draw_section_header(stdscr, row, panel_x, "SET BREAKDOWN", panel_w - 1, 1)
        except curses.error:
            pass
        row += 1

        max_set_val = max(sets_data) if sets_data else 1
        for i, reps in enumerate(sets_data):
            if row >= panel_y + panel_h - 4:
                break
            if i < current_set:
                status_icon = "✓"
                s_color = 2
                bar_val = reps
            elif i == current_set and phase == "RUNNING":
                status_icon = spinner_chars[animation_frame]
                s_color = 3
                bar_val = set_progress
            else:
                status_icon = "○"
                s_color = 8
                bar_val = 0

            set_bar_w = panel_w - 28
            try:
                stdscr.addstr(row, panel_x + 2, f"Set {i+1:>2}  {status_icon}  ", curses.color_pair(s_color) | curses.A_BOLD)
                draw_bar(stdscr, row, panel_x + 14, bar_val, reps, set_bar_w, get_bar_color(bar_val / reps if reps else 0))
                stdscr.addstr(row, panel_x + 14 + set_bar_w + 1, f"{bar_val:>4}/{reps:<4}", curses.color_pair(s_color))
            except curses.error:
                pass
            row += 1

        try:
            draw_section_header(stdscr, row, panel_x, "STATS", panel_w - 1, 1)
        except curses.error:
            pass
        row += 1

        cols = 3
        col_w = (panel_w - 4) // cols
        stats = [
            ("TARGET", f"{target} reps", 6),
            ("DONE", f"{current_rep} reps", 2),
            ("SETS", f"{num_sets} sets", 3),
            ("REMAINING", f"{max(0, target - current_rep)} reps", 4),
            ("SETS LEFT", f"{max(0, num_sets - current_set)}", 3),
            ("INTENSITY", f"{'HIGH' if target > 400 else 'MED' if target > 250 else 'LOW'}", get_bar_color(target / 600)),
        ]
        for idx, (label, val, col) in enumerate(stats):
            if row + idx // cols >= panel_y + panel_h - 3:
                break
            r = row + idx // cols
            c = panel_x + 2 + (idx % cols) * col_w
            try:
                stdscr.addstr(r, c, f"{label}: ", curses.color_pair(8))
                stdscr.addstr(r, c + len(label) + 2, val, curses.color_pair(col) | curses.A_BOLD)
            except curses.error:
                pass

        row += (len(stats) + cols - 1) // cols

        if phase == "DONE":
            try:
                done_msg = "🎉  GREAT JOB! WORKOUT COMPLETE!  🎉"
                dx = panel_x + (panel_w - len(done_msg)) // 2
                stdscr.addstr(row, max(panel_x + 1, dx), done_msg[:panel_w - 3], curses.color_pair(2) | curses.A_BOLD)
            except curses.error:
                pass
            row += 1

        try:
            hint = " [Q] Quit "
            stdscr.addstr(panel_y + panel_h - 1, panel_x + 2, hint, curses.color_pair(7))
        except curses.error:
            pass

        stdscr.refresh()
        time.sleep(0.05)


if __name__ == "__main__":
    curses.wrapper(main)

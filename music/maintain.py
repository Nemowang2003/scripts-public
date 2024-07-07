from pathlib import Path
from eyed3 import load
from subprocess import run, DEVNULL

BASEPATH = Path.home() / "Music"


def COLOR(code, s):
    return f"\033[{code}m{s}\033[0m"


def RED(s):
    return COLOR(91, s)


def GREEN(s):
    return COLOR(92, s)


def YELLOW(s):
    return COLOR(93, s)


def ERROR(s):
    print(f'{RED("Error")}: {s}')


def NOTE(s):
    print(f'{GREEN("Note")}: {s}')


def WARNING(s):
    print(f'{YELLOW("Warning")}: {s}')


def convert_helper(old: Path, new: Path):
    content = bytearray(old.open("rb").read())
    content = bytearray(map(lambda x: x ^ 163, content))
    new.open("wb").write(content)
    old.unlink()


def convert() -> int:
    path = (
        Path.home()
        / "Library/Containers/com.netease.163music/Data/Caches/online_play_cache"
    )
    existing = (
        max(map(lambda x: int(x.name[:-4]), BASEPATH.glob("*.mp3")), default=-1) + 1
    )
    index = -1
    for index, name in enumerate(path.glob("*.uc!")):
        NOTE(f"Generating {index + existing}.mp3")
        convert_helper(name, BASEPATH / f"{index + existing}.mp3")
    return existing + index


def backup_helper(source: Path, target: Path):
    target = target / source.name
    if target.exists():
        WARNING(f"A file with same name of {source} exists, skipping.")
    elif not source.name.endswith("mp3"):
        WARNING(f"{source} might not be a music file, skipping.")
    else:
        NOTE(f"Processing {source}.")
        source.replace(target)
        source.symlink_to(target)


def backup_dir(dirname: Path, target: Path):
    for filename in filter(
        lambda filename: filename.name != ".localized", dirname.iterdir()
    ):
        if filename.is_dir():
            backup_dir(filename, target)
        elif not filename.is_symlink():
            backup_helper(filename, target)
        elif not filename.exists() and filename.is_symlink():
            WARNING(f"{filename} is an invalid symlink, deleting.")
            filename.unlink()
            # filename.symlink_to(target / filename.name)


def duplication_check(path: Path):
    print("Performing duplication check.")
    for file in (BASEPATH / "All.localized").glob("*.mp3"):
        if not run(
            ["diff", "-q", file, path], stdout=DEVNULL, stderr=DEVNULL
        ).returncode:
            NOTE(f"{path} is identical to {file}, deleting.\n")
            path.unlink()
            return True
    NOTE("No duplicated files found.\n")
    return False


def arrange(number: int):
    for index in range(number):
        path = BASEPATH / f"{index}.mp3"
        if not path.exists():
            continue
        NOTE(f"Processing {path}.")
        file = load(path)
        duration = int(file._info.time_secs)
        mins = duration // 60
        secs = duration % 60
        print(
            f'Duration: {mins} min{"s" if mins != 1 else ""} {secs:02} sec{"s" if secs != 1 else ""}.'
        )
        try:
            if file.tag and file.tag.title:
                print(
                    f'Title: {file.tag.title.encode('raw_unicode_escape').decode('gbk')}.\n'
                )
            else:
                print("No other metadata found.")
            if duplication_check(path):
                continue
            name = input("Name for this file:\n")
            dirname = input("Artist name of this file:\n")
            if not (new_dir := BASEPATH / f"{dirname}.localized").exists():
                NOTE("You are creating a new directory.")
                display = input("Display name for this artist:\n")
                (localization := new_dir / ".localized").mkdir(parents=True)
                (localization / "zh.strings").open("w").write(
                    f'"{dirname}" = "{display}";\n'
                )
            while (file := new_dir / f"{name}.mp3").exists():
                ERROR("File exists.")
                name = input("Name for this file:\n")
            print()
            NOTE(f"Moving {path} to {file}.\n")
            path.rename(file)
        except EOFError:
            WARNING(f"Detected EOF, skipping arrangement for {path}.\n")


def backup():
    target = BASEPATH / "All.localized"
    dirnames = filter(
        lambda dirname: dirname != target and dirname.is_dir(), BASEPATH.iterdir()
    )
    for dirname in dirnames:
        backup_dir(dirname, target)


if __name__ == "__main__":
    for name in "Music", "网易云音乐":
        rubbish = BASEPATH / name
        if rubbish.exists():
            from shutil import rmtree

            rmtree(rubbish)
    if number := convert() + 1:
        NOTE("Entering interactive console for arrangment.\n")
        arrange(number)
    backup()
    print(GREEN("Finished!"))

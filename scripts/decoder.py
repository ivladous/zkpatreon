import sys
from helpers import bigint_to_string


def main():
    decoded = bigint_to_string(int(sys.argv[1]))
    print(f"Decoded: {decoded}")


if __name__ == "__main__":
    main()

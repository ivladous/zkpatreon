import sys
from helpers import string_to_bigint


def main():
    encoded = string_to_bigint(sys.argv[1])
    print(f"Encoded: {encoded}")


if __name__ == "__main__":
    main()

# Example
url = "https://youtu.be/dQw4w9WgXcQ"

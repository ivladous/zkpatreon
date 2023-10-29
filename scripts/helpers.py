def string_to_bigint(s: str) -> int:
    # Convert the string to bytes using UTF-8 encoding.
    byte_representation = s.encode("utf-8")

    # Convert the bytes to a big integer.
    bigint = int.from_bytes(byte_representation, byteorder="big")

    return bigint


def bigint_to_string(i: int) -> str:
    # Convert the bigint back to bytes.
    byte_representation = i.to_bytes((i.bit_length() + 7) // 8, byteorder="big")

    # Convert the bytes back to a string using UTF-8 encoding.
    return byte_representation.decode("utf-8")

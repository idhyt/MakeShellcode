#!/usr/bin/env python

from sys import argv


def chunk(iterable, chunk_size):
    """Divide iterable into chunks of chunk_size"""
    for i in range(0, len(iterable), chunk_size):
        yield iterable[i:i+chunk_size]


def main():
    if len(argv) < 2:
        print('Usage: {} <shellcode> [<bytes/line>]'.format(argv[0]))
        exit(1)

    line_len = 8
    if len(argv) > 2:
        line_len = int(argv[2])

    sc = file(argv[1]).read()

    print('var JavaScript_shellcode = new Uint8Array([')
    hex_bytes = ['0x{}'.format(i.encode('hex').zfill(2)) for i in sc]
    for i in chunk(hex_bytes, line_len):
        s = '{},'.format(r', '.join(i))
        print('    {}'.format(s))
    print('])')
    
    print('char C_shellcode[] = ')
    hex_bytes = [i.encode('hex').zfill(2) for i in sc]
    for i in chunk(hex_bytes, line_len):
        s = '"{}"'.format(r'\x' + r'\x'.join(i))
        print('    {}'.format(s))


if __name__ == '__main__':
    main()

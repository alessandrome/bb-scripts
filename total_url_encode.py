import sys

def url_encode_all(input_string, double_encode=False):
    """
    Converte tutti i caratteri di una stringa in URL encoding.
    Se double_encode è True, applica un doppio encoding.
    """
    if double_encode:
        encoded = ''.join(f'%{ord("%"):02X}{ord(c):02X}' for c in input_string)
    else:
        encoded = ''.join(f'%{ord(c):02X}' for c in input_string)
    return encoded

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python script.py <string> [--double]")
        sys.exit(1)
    
    input_string = sys.argv[1]
    double_encode = '--double' in sys.argv

    encoded_string = url_encode_all(input_string, double_encode)
    print(encoded_string)

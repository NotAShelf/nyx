_: let
  inherit (builtins) match toInt splitString length all;
  # Check if a string represents a number within the range 0-255, a.k.a an IPv4 octet
  isValidOctet = n: match "[0-9]{1,3}" n != null && (toInt n <= 255);

  # Main function to check if a string is a valid IPv4 address
  isValidIPv4 = ip: let
    parts = splitString "." ip;
  in
    length parts == 4 && all isValidOctet parts;
in {
  inherit isValidIPv4;
}

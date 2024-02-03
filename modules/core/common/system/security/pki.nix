{lib, ...}: {
  security.pki = {
    certificates = lib.mkForce [];
    caCertificateBlacklist = [
      #
      "AC RAIZ FNMT-RCM SERVIDORES SEGUROS"
      "Autoridad de Certificacion Firmaprofesional CIF A62634068"

      # China Financial Certification Authority
      "CFCA EV ROOT"

      # Chunghwa Telecom Co., Ltd
      "ePKI Root Certification Authority"
      "HiPKI Root CA - G1"

      # Dhimyotis
      "Certigna"
      "Certigna Root CA"

      # GUANG DONG CERTIFICATE AUTHORITY
      "GDCA TrustAUTH R5 ROOT"

      # Hongkong Post
      "Hongkong Post Root CA 3"

      # iTrusChina Co.,Ltd.
      "vTrus ECC Root CA"
      "vTrus Root CA"

      # Krajowa Izba Rozliczeniowa S.A.
      "SZAFIR ROOT CA2"

      # NetLock Kft.
      "NetLock Arany (Class Gold) Főtanúsítvány"

      # TAIWAN-CA
      "TWCA Root Certification Authority"
      "TWCA Global Root CA"
    ];
  };
}

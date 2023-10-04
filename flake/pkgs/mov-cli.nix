{
  lib,
  pkgs,
  python3,
  fetchFromGitHub,
  fetchPypi,
}:
python3.pkgs.buildPythonPackage rec {
  pname = "mov-cli";
  version = "1.5.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "mov-cli";
    repo = "mov-cli";
    rev = "${version}";
    hash = "sha256-ixv9guHfXy1kQbpAWAVwPtpxX5IwAQ8CQ2hvhM7sewg=";
  };

  propagatedBuildInputs = [
    pkgs.python310Packages.poetry-core
    pkgs.python310Packages.pycryptodome
    pkgs.python310Packages.lxml
    pkgs.python310Packages.six
    pkgs.python310Packages.beautifulsoup4
    pkgs.python310Packages.tldextract
    (pkgs.python310Packages.httpx.overrideAttrs (_old: {
      src = fetchFromGitHub {
        owner = "encode";
        repo = "httpx";
        rev = "refs/tags/0.24.0";
        hash = "sha256-eLCqmYKfBZXCQvFFh5kGoO91rtsvjbydZhPNtjL3Zaw=";
      };
    }))
    (
      python3.pkgs.buildPythonPackage rec {
        pname = "krfzf_py";
        version = "0.0.4";
        src = fetchPypi {
          inherit pname version;
          sha256 = "sha256-W0wpR1/HRrtYC3vqEwh+Jwkgwnfa49LCFIArOXaSPCE=";
        };
      }
    )
  ];

  meta = with lib; {
    homepage = "https://github.com/mov-cli/mov-cli";
    description = "A cli tool to browse and watch movies";
    license = licenses.gpl3Only;
    mainProgram = "mov-cli";
  };
}

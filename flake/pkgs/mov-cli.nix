{
  lib,
  pkgs,
  python3Packages,
  fetchFromGitHub,
  fetchPypi,
}:
python3Packages.buildPythonPackage rec {
  pname = "mov-cli";
  version = "1.5.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "mov-cli";
    repo = "mov-cli";
    rev = "${version}";
    hash = "sha256-ixv9guHfXy1kQbpAWAVwPtpxX5IwAQ8CQ2hvhM7sewg=";
  };

  propagatedBuildInputs = with python3Packages; [
    poetry-core
    pycryptodome
    lxml
    six
    beautifulsoup4
    tldextract
    (python3Packages.httpx.overrideAttrs (_old: {
      src = fetchFromGitHub {
        owner = "encode";
        repo = "httpx";
        rev = "refs/tags/0.24.0";
        hash = "sha256-eLCqmYKfBZXCQvFFh5kGoO91rtsvjbydZhPNtjL3Zaw=";
      };
    }))
    (
      python3Packages.buildPythonPackage rec {
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

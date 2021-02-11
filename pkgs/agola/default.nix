{ stdenv, lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "agola";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "agola-io";
    repo = "agola";
    rev = "v${version}";
    hash = sha256:1glm7slw2d67alpcdbp32pwpg8d78frv875780cqn59sm7svqj2j;
  };

  vendorSha256 = "15px4ylg5hfc8pysgjnpqgsna8jcx7mczkmgh1zyzn31lzgq1yk5";

  meta = with lib; {
    description = "CI/CD redefined";
    homepage = "https://agola.io";
    license = licenses.mit;
    maintainers = with maintainers; [ igsha ];
  };
}

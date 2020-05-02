{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "agola";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "agola-io";
    repo = "agola";
    rev = "v${version}";
    hash = sha256:1glm7slw2d67alpcdbp32pwpg8d78frv875780cqn59sm7svqj2j;
  };

  modSha256 = "1ki354f8a3qh90q5xd7x7l3b1piq7b1s0gxqmwr878axdbx4c41i";

  meta = with stdenv.lib; {
    description = "CI/CD redefined";
    homepage = "https://agola.io";
    license = licenses.mit;
    maintainers = with maintainers; [ igsha ];
  };
}

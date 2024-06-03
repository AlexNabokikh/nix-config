{
  fetchgit,
  lib,
  nodejs,
  gettext,
  just,
  zip,
  unzip,
  libarchive,
  buildNpmPackage,
  glib,
}:
buildNpmPackage {
  pname = "rounded-window-corners-reborn";
  version = "latest";

  src = fetchgit {
    url = "https://github.com/flexagoon/rounded-window-corners";
    rev = "096a70f416a26f0b3eeb477b762c775afabbd5e0";
    hash = "sha256-swB9pA0l44HpDzFexipQ7LeU22WAIFe5uNCknd4ZzuY=";
  };

  npmDepsHash = "sha256-2brE1GlzyHN9G/161aKiuHVVbjrpnN/0FBwuBDg/8W0=";

  nativeBuildInputs = [nodejs gettext just zip unzip libarchive glib];

  buildPhase = ''
    just pack
  '';

  installPhase = ''
    mkdir -p $out/share/gnome-shell/extensions
    install -d $out/share/gnome-shell/extensions/rounded-window-corners@fxgn
    bsdtar -xvf "rounded-window-corners@fxgn.shell-extension.zip" -C "$out/share/gnome-shell/extensions/rounded-window-corners@fxgn" --no-same-owner
    mv $out/share/gnome-shell/extensions/rounded-window-corners@fxgn/locale $out/share/
    install -Dm644 "$out/share/gnome-shell/extensions/rounded-window-corners@fxgn/schemas/org.gnome.shell.extensions.rounded-window-corners.gschema.xml" -t "$out/share/glib-2.0/schemas/"
  '';

  meta = with lib; {
    description = "Rounded window corners";
    license = licenses.gpl3;
    homepage = "https://github.com/p-e-w/argos";
  };
}

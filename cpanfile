# This file is generated by Dist::Zilla::Plugin::CPANFile v6.024
# Do not edit this file directly. To change prereqs, edit the `dist.ini` file.

requires "Attribute::Handlers" => "0";
requires "Exporter::Tiny" => "0";
requires "Syntax::Construct" => "0";
requires "parent" => "0";
requires "perl" => "5.014";
requires "strict" => "0";
requires "warnings" => "0";

on 'build' => sub {
  requires "Module::Build" => "0.28";
};

on 'test' => sub {
  requires "Test::Deep" => "0";
  requires "Test::More" => "0";
  requires "Test::Tester" => "0";
  requires "Test::Warnings" => "0";
};

on 'configure' => sub {
  requires "Module::Build" => "0.28";
};

on 'develop' => sub {
  requires "Test::EOL" => "0";
  requires "Test::More" => "0.88";
};

#!/usr/bin/perl
use warnings;
use strict;

use Module::Build;

Module::Build->new(
    module_name => 'Bot::BasicBot::Pluggable::Module::Delicious',
    license => 'perl',
    requires => {
      'Net::Delicious'           => '0',
      'Bot::BasicBot::Pluggable' => '0',
      'URI::Find'                => 0,
    },
    create_makefile_pl => 'traditional',
    create_readme => 1,
)->create_build_script;


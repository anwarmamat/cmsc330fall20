require "minitest/autorun"
require "open3"

#
# Constants
#

VERSION = /(\d+(\.\d+))/
OCAML_VERSION = "4.11"
OPAM_VERSION = "2.0"

#
# Required Packages
#

class PublicTests < Minitest::Test
  def test_public_ocaml
    assert(ocaml_version, not_installed("OCaml"))
    assert_equal(OCAML_VERSION, ocaml_version, wrong_version("OCaml"))
  end

  def test_public_opam
    assert(opam_version, not_installed("OPAM"))
    assert_equal(OPAM_VERSION, opam_version, wrong_version("OPAM"))
  end

  def test_public_sqlite3
    assert(sqlite3_version, not_installed("SQLite3"))
  end

  def test_public_ruby_gems
    assert(gem_version("minitest"), not_installed("MiniTest gem"))
    assert(gem_version("sinatra"), not_installed("Sinatra gem"))
    assert(gem_version("sqlite3"), not_installed("SQLite3 gem"))
  end

  def test_public_ocaml_pkgs
    assert(ocaml_pkg_version("ounit"), not_installed("OUnit pkg"))
    assert(ocaml_pkg_version("dune"), not_installed("dune pkg"))
    assert(ocaml_pkg_version("utop"), not_installed("utop pkg"))
  end

  def test_public_graphviz
    assert(graphviz_version, not_installed("Graphviz"))
  end
end

#
# Helpers
#

def not_installed(name)
  "#{name} is not installed"
end

def wrong_version(name)
  "The wrong version of #{name} is installed"
end

def optional_warn(msg)
  puts "OPTIONAL: #{msg}"
end

def match_version(cmd)
  stdout, stderr, _ = Open3.capture3("#{cmd};")
  (stdout =~ VERSION or stderr =~ VERSION) and $1
end

#
# Version Checkers
#

def ocaml_version
  match_version("ocaml -version")
end

def opam_version
  match_version("opam --version")
end

def graphviz_version
  match_version("dot -V")
end

def sqlite3_version
  match_version("sqlite3 -version")
end

def gem_version(name)
  spec = Gem::Specification.find { |s| s.name == name }
  spec and spec.version.version
end

def ocaml_pkg_version(name)
  `opam info #{name}`.encode("UTF-8", "UTF-8") =~ /all-installed-versions/
end

#
# Results Reporter
#

module Minitest
  class SubmitReporter < AbstractReporter
    attr_accessor :results

    def initialize(options)
      self.results = []
    end

    def record result
      self.results << result
    end

    def report
      result_hashes = results.map do |result|
        { :name => result.name,
          :assertions => result.assertions,
          :failures => result.failures
        }
      end

      File.open("p0.report", "w") do |f|
        Marshal.dump(result_hashes, f)
      end
    end
  end

  def self.plugin_submit_init(options)
    self.reporter << SubmitReporter.new(options)
  end

  self.extensions << "submit"
end

# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/extensiontask'
require 'rake/testtask'
require 'test_queue'
require 'test_queue/runner/minitest'
require 'fileutils'

COPY_TARGETS = %w[
  ccan/check_type/check_type.h
  ccan/container_of/container_of.h
  ccan/list/list.h
  ccan/str/str.h
  constant.h
  id_table.h
  internal/array.h
  internal/basic_operators.h
  internal/bignum.h
  internal/bits.h
  internal/compile.h
  internal/compilers.h
  internal/complex.h
  internal/encoding.h
  internal/error.h
  internal/fixnum.h
  internal/gc.h
  internal/hash.h
  internal/imemo.h
  internal/io.h
  internal/numeric.h
  internal/parse.h
  internal/rational.h
  internal/re.h
  internal/ruby_parser.h
  internal/sanitizers.h
  internal/serial.h
  internal/static_assert.h
  internal/string.h
  internal/symbol.h
  internal/thread.h
  internal/variable.h
  internal/warnings.h
  internal/vm.h
  internal.h
  method.h
  node.c
  node.h
  parse.y
  parser_bits.h
  parser_node.h
  parser_st.c
  parser_st.h
  parser_value.h
  ruby_assert.h
  ruby_atomic.h
  ruby_parser.c
  rubyparser.h
  shape.h
  st.c
  symbol.h
  thread_pthread.h
  universal_parser.c
  vm_core.h
  vm_opts.h
].freeze

namespace :ruby_parser do
  desc 'import ruby parser files'
  task :import do
    `git clone https://github.com/ruby/ruby.git tmp/ruby --depth=1`

    dist = File.expand_path('ext/kanayago', __dir__)
    ruby_dir = File.expand_path('tmp/ruby', __dir__)

    directories = ['ccan', 'ccan/check_type', 'ccan/container', 'ccan/container_of', 'ccan/list', 'ccan/str',
                   'internal']

    directories.each do |dir|
      Dir.mkdir File.join(dist, dir)
    end

    COPY_TARGETS.each do |target|
      FileUtils.cp File.join(ruby_dir, target), File.join(dist, target)
    end

    # "parse.tmp.y"
    id2token_path = File.join(ruby_dir, 'tool/id2token.rb')
    parse_y_path = File.join(dist, 'parse.y')
    parse_tmp_y_path = File.join(dist, 'parse.tmp.y')
    sh "ruby #{id2token_path} #{parse_y_path} > #{parse_tmp_y_path}"

    # "id.h"
    generic_erb_path = File.join(ruby_dir, 'tool/generic_erb.rb')
    id_h_tmpl_path = File.join(ruby_dir, 'template/id.h.tmpl')
    id_h_path = File.join(dist, 'id.h')
    sh "ruby #{generic_erb_path} --output=#{id_h_path} #{id_h_tmpl_path}"

    # "probes.h"
    probes_h_path = File.join(dist, 'probes.h')
    File.open(probes_h_path, 'w+') do |f|
      f << <<~SRC
        #define RUBY_DTRACE_PARSE_BEGIN_ENABLED() (0)
        #define RUBY_DTRACE_PARSE_BEGIN(arg0, arg1) (void)(arg0), (void)(arg1);
        #define RUBY_DTRACE_PARSE_END_ENABLED() (0)
        #define RUBY_DTRACE_PARSE_END(arg0, arg1) (void)(arg0), (void)(arg1);
      SRC
    end

    # "node_name.inc"
    node_name_path = File.join(ruby_dir, 'tool/node_name.rb')
    rubyparser_h_path = File.join(dist, 'rubyparser.h')
    node_name_inc_path = File.join(dist, 'node_name.inc')
    sh "ruby -n #{node_name_path} < #{rubyparser_h_path} > #{node_name_inc_path}"

    # "lex.c"
    sh 'cd tmp/ruby && ./autogen.sh && ./configure && make'
    FileUtils.mv File.join(ruby_dir, 'lex.c'), File.join(dist, 'lex.c')

    `rm -rf tmp/ruby`
  end

  desc 'build ruby parse.c and parse.h with lrama'
  task :build do
    sh 'bundle exec lrama -oext/kanayago/parse.c -Hext/kanayago/parse.h ext/kanayago/parse.tmp.y'
  end

  desc 'clean to ruby parser file'
  task :clean do
    dist = File.expand_path('./ext/kanayago')

    COPY_TARGETS.each do |target|
      FileUtils.rm File.join(dist, target), force: true
    end
    delete_files = ['constant.h', 'id.h', 'id.h', 'id.h', 'id_table.h', 'lex.c', 'node_name.inc', 'parse.c', 'parse.h',
                    'parse.y', 'parse.tmp.y', 'probes.h', 'shape.h']

    delete_files.each do |file|
      FileUtils.rm File.join(dist, file), force: true
    end

    delete_directories = %w[ccan internal]

    delete_directories.each do |dir|
      FileUtils.rm_rf File.join(dist, dir)
    end
  end
end

task build: ['ruby_parser:build', 'compile']
task install: ['ruby_parser:build', 'compile']

GEMSPEC = Gem::Specification.load('kanayago.gemspec')

Rake::ExtensionTask.new('kanayago', GEMSPEC) do |ext|
  ext.lib_dir = 'lib/kanayago'
end

namespace :queue do
  desc 'run test with test-queue'
  task :test do
    sh 'bundle exec minitest-queue $(find test/ -name \*_test.rb)'
  end
end

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

desc 'try to kanayago code'
task :run do
  sh 'ruby test.rb'
end

desc 'debug to kanayago code in gdb'
task :gdb do
  sh 'bundle exec gdb --args ruby test.rb'
end

task default: %i[clobber compile]

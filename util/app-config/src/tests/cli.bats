#!/usr/bin/env bats
bats_load_library 'bats-assert'
bats_load_library 'bats-support'

_short() {
  bash -c "ckb -V"
}
_long() {
  bash -c "ckb --version"
}
_help() {
  bash -c "ckb -h"
}
_list_hashes() {
  bash -c "ckb list-hashes -C ${CKB_DIRNAME}"
}
_list_bundle_hashes() {
  bash -c "ckb list-hashes -C ${CKB_DIRNAME} -b"
}
_stats_default() {
  bash -c "ckb stats -C ${CKB_DIRNAME}"
}
_stats_with_range() {
  bash -c "ckb stats -C ${CKB_DIRNAME} --from 1 --to 500"
}
_full_help() {
  bash -c "ckb help"
}

#@test "ckb -V" {
function short_version { #@test
  run _short
  assert_success
  assert_output --regexp "^ckb [0-9.]+[-]?[a-z]*$"
}

#@test "ckb --version" {
function long_version { #@test
  run _long
  assert_success
  assert_output --regexp "^ckb [0-9.]+-.*\([0-9a-z-]+ [0-9]{4}-[0-9]{2}-[0-9]{2}\)$"
}

function help { #@test
  run _help
  assert_success
  assert_output --regexp ".*Usage:.*Commands:.*Options:.*"

  run _full_help
  assert_success
  assert_output --regexp ".*Usage:.*Commands:.*Options:.*"
}

function list_hashes { #@test
  run _list_hashes
  assert_success
  assert_line --index 0 '# Generated by: ckb list-hashes'
  assert_line --index 1 '[ckb]'
  assert_line --index 2 --regexp 'spec_hash = "0x[0-9a-fA-F]{64}"'
  assert_line --index 3 --regexp 'genesis = "0x[0-9a-fA-F]{64}"'
  assert_line --index 4 --regexp 'cellbase = "0x[0-9a-fA-F]{64}"'
}

function list_bundle_hashes { #@test
  run _list_bundle_hashes
  assert_success
  assert_line --index 0 '# Generated by: ckb list-hashes -b'
  assert_line --index 1 '[ckb]'
  assert_line --index 2 --regexp 'spec_hash = "0x[0-9a-fA-F]{64}"'
  assert_line --index 3 --regexp 'genesis = "0x[0-9a-fA-F]{64}"'
  assert_line --index 4 --regexp 'cellbase = "0x[0-9a-fA-F]{64}"'
}

function stats_default { #@test
  run _stats_default
  assert_success
  assert_output --regexp "uncle_rate:.*by_miner_script:.*by_miner_message:.*"
}

function stats_with_range { #@test
  run _stats_with_range
  assert_success
  assert_output --regexp "uncle_rate:.*by_miner_script:.*by_miner_message:.*"
}

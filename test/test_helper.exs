Code.require_file "support/test_repo.exs", __DIR__

# For mix tests
Mix.shell(Mix.Shell.Process)

ExUnit.start()
Application.ensure_all_started(:bypass)

defmodule MixHelper do
  import ExUnit.Assertions

  def tmp_path do
    Path.expand("../tmp", __DIR__)
  end

  def in_tmp(which, function) do
    path = Path.join(tmp_path, which)
    File.rm_rf! path
    File.mkdir_p! path
    File.cd! path, function
  end

  def assert_file(file) do
    assert File.regular?(file), "Expected #{file} to exist, but does not"
  end

  def assert_file(file, match) do
    cond do
      is_list(match) ->
        assert_file file, &(Enum.each(match, fn(m) -> assert &1 =~ m end))
      is_binary(match) or Regex.regex?(match) ->
        assert_file file, &(assert &1 =~ match)
      is_function(match, 1) ->
        assert_file(file)
        match.(File.read!(file))
    end
  end

  def with_generator_env(new_env, fun) do
    old = Application.get_env(:dayron, :generators)
    Application.put_env(:dayron, :generators, new_env)
    try do
      fun.()
    after
      Application.put_env(:dayron, :generators, old)
    end
  end
end

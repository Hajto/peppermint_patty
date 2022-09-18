defmodule PeppermintPatty.FileTest do
  use ExUnit.Case, async: false

  alias PeppermintPatty.File, as: Patty

  describe "open/2" do
    test "when opening a localfile returns a stream" do
      tmp_file = "/tmp/peppermint_patty"
      contents = "File contents!"
      File.write!(tmp_file, contents, [:write])

      assert {:ok, %Patty.Stream{stream: stream}} = Patty.open(tmp_file)
      assert Enum.join(stream) == contents
    end

    for schema <- ["http", "https"] do
      test "when reaching #{schema} remote, binary response results in PattyFile.InMemory" do
        url = unquote("#{schema}://path.com/to/the_file?query=params")
        contents = "File contents!"

        Tesla.Mock.mock(fn env ->
          assert env.url == url
          assert env.method == :get

          %Tesla.Env{env | body: contents, status: 200}
        end)

        assert {:ok, %PeppermintPatty.File.InMemory{content: "File contents!"}} == Patty.open(url)
      end
    end

    for schema <- ["http", "https"] do
      test "when reaching #{schema} remote, stream results in PattyFile.Stream" do
        url = unquote("#{schema}://path.com/to/the_file?query=params")
        contents = "File contents!"
        stream = contents |> StringIO.open() |> elem(1) |> IO.binstream(:line)

        Tesla.Mock.mock(fn env ->
          assert env.url == url
          assert env.method == :get

          %Tesla.Env{env | body: stream, status: 200}
        end)

        assert {:ok, %PeppermintPatty.File.Stream{stream: stream}} == Patty.open(url)
        assert Enum.join(stream) == contents
      end
    end

    test "error results in error tuple" do
      assert {:error, :enoent} == Patty.open("/tmp/files/that/does/not/exist")
    end
  end
end

import std;

int main(string[] args)
{
    spawnProcess(["df", "."], stdin, File("/dev/null", "w"), File("/dev/null", "w")).wait();
    auto _out = File("/dev/null", "w");
    auto _err = File("/dev/null", "w");
    spawnProcess(["df", "."], stdin, _out, _err).wait();
    return 0;
}

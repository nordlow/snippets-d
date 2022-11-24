#include <unordered_map>
#include <iostream>

using namespace std;

// https://kaleidic.slack.com/archives/C9FJ6J5E3/p1633566744201500?thread_ts=1633513949.147400&cid=C9FJ6J5E3
int main()
{
    {
        unordered_map<string, int> c;
        cout << ++c["a"] << endl; // pass
    }
    {
        unordered_map<string, int> c;
        cout << c["a"]++ << endl; // pass
    }
	return 0;
}

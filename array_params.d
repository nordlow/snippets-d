/**
 * See_Also: https://discord.com/channels/242094594181955585/811702037532115015/1019204522553393283
 * See_Also: https://stackoverflow.com/questions/73702428/passing-t-and-t-arguments-freely-intermixed
 */

int main(string[] args) {
	f(1,2,3);
	f([1,2,3]);
	f(1,2,3,[4,5]);				// shouldn’t fail
	f([1,2,3],4,5);				// shouldn’t fail
	return 0;
}

void f(T)(T[] params...) {
}

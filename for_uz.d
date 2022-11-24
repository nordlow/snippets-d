int main(string[] _) {
	const size_t l = 0;
	/* TODO: this is not allowed in C++23 and requires auto i = 0uz. See
	 * https://youtu.be/b0NkuoUkv0M?t=663 */
	for (auto i = 0; i != l; i++) {
	}
	return 0;
}

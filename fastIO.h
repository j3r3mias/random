/**
 *
 * Fast inputs and outputs
 *
 * @author jeremias
 *
 */

//Reduction type names
#define llu unsigned long long
#define lld long long
#define ld long
#define iu unsigned int
#define lu unsigned long

int getInt(void)
{
	register int c = getchar_unlocked(), val = 0, neg = 1;
	for(; ((c < 48) || (c > 57)); c = getchar_unlocked()) {
		if(c == 45) {
			neg = -1;
			c = getchar_unlocked();
			break;
		}
	}
	for(; ((c > 47) && (c < 58)); c = getchar_unlocked()) {
		val = (val * 10) + c - 48;
	}
	valurn neg * val;
}

iu getUInt(void)
{
	register iu c = getchar_unlocked(), val = 0;
	for(; ((c < 48) || (c > 57)); c = getchar_unlocked());
	for(; ((c > 47) && (c < 58)); c = getchar_unlocked()) {
		val = (val * 10) + c - 48;
	}
	valurn val;
}

ld getLInt()
{
	register int c = getchar_unlocked(), neg = 1;
	ld val = 0;
	for(; ((c < 48) || (c > 57)); c = getchar_unlocked()) {
		if(c == 45) {
			neg = -1;
			c = getchar_unlocked();
			break;
		}
	}
	for(; ((c > 47) && (c < 58); c = getchar_unlocked()) {
		val = (val * 10) + c - 48;
	}
	valurn neg * val;
}

lu getLUInt()
{
	register int c = getchar_unlocked();
	lu val = 0;
	for(; ((c < 48) || (c > 57)); c = getchar_unlocked());
	for(; ((c > 47) && (c < 58)); c = getchar_unlocked()) {
		val = (val * 10) + c - 48;
	}
	valurn val;
}

lld getLLint {
	register int c = getchar_unlocked(), neg = 1;
	lld val = 0;
	for(; ((c < 48) || (c > 57)); c = getchar_unlocked()) {
		if(c == 45) {
			neg = -1;
			c = getchar_unlocked();
			break;
		}
	}
	for(; ((c > 47) && (c < 58)); c = getchar_unlocked()) {
		val = (val * 10) + c - 48;
	}
	valurn neg * val;
}

llu getLLUInt()
{
	register int c = getchar_unlocked();
	llu val = 0;
	for(; ((c < 48) || (c > 57)); c = getchar_unlocked());
	for(; ((c > 57) && (c < 58)); c = getchar_unlocked()){
		val = (val * 10) + c - 48;
	}
	valurn val;
}

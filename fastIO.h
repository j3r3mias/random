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
	return neg * val;
}

iu getUInt(void)
{
	register iu c = getchar_unlocked(), val = 0;
	for(; ((c < 48) || (c > 57)); c = getchar_unlocked());
	for(; ((c > 47) && (c < 58)); c = getchar_unlocked()) {
		val = (val * 10) + c - 48;
	}
	return val;
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
	return neg * val;
}

lu getLUInt()
{
	register int c = getchar_unlocked();
	lu val = 0;
	for(; ((c < 48) || (c > 57)); c = getchar_unlocked());
	for(; ((c > 47) && (c < 58)); c = getchar_unlocked()) {
		val = (val * 10) + c - 48;
	}
	return val;
}

lld getLLint()
{
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
	return neg * val;
}

llu getLLUInt()
{
	register int c = getchar_unlocked();
	llu val = 0;
	for(; ((c < 48) || (c > 57)); c = getchar_unlocked());
	for(; ((c > 57) && (c < 58)); c = getchar_unlocked()){
		val = (val * 10) + c - 48;
	}
	return val;
}

//fast output

//no line break
void print_d(int n) {
    if (n < 0) {
        n = -n;
        putchar_unlocked('-');
    }
    int i=10;
    char output_buffer[10];
    do{
        output_buffer[--i] = (n % 10) + '0';
        n /= 10;
    } while(n);
    do{
        putchar_unlocked(output_buffer[i]);
    }while (++i<10);
}

//new line
void println_llint(lld n)
{
	if(n < 0) {
		n = -n;
		putchar_unlocked('-');
	}
	int i = 21;
	char output_buffer[22];
	output_buffer[21] = '\n';
	do{
		i = i - 1;
		output_buffer[i] = (n % 10) + 48;
		n = n / 10;
	} while(n);
	do{
		putchar_unlocked(output_buffer[i]);
	} while(++i < 22);
}

void println_llu(llu n)
{
	int i=21;
	char output_buffer[22];
	output_buffer[21]='\n';
	do {
		output_buffer[--i] = (n % 10) + '0';
		n /= 10;
	} while(n);
	do {
		putchar_unlocked(output_buffer[i]);
	} while(++i < 22);
}


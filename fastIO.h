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
	register int ip = getchar_unlocked(), ret = 0, flag = 1;
	for(; ((ip < 48) || (ip > 57)); ip = getchar_unlocked()) {
		if(ip == 45) {
			flag = -1;
			ip = getchar_unlocked();
			break;
		}
	}
	for(; ((ip > 47) && (ip < 58)); ip = getchar_unlocked()) {
		ret = (ret * 10) + ip - 48;
	}
	return flag * ret;
}

iu getUInt(void)
{
	register iu ip = getchar_unlocked(), ret = 0;
	for(; ((ip < 48) || (ip > 57)); ip = getchar_unlocked());
	for(; ((ip > 47) && (ip < 58)); ip = getchar_unlocked()) {
		ret = (ret * 10) + ip - 48;
	}
	return ret;
}

ld getLInt()
{
	register int ip = getchar_unlocked(), flag = 1; 
	ld ret = 0;
	for(; ((ip < 48) || (ip > 57)); ip = getchar_unlocked()) { 
		if(ip == 45) {
			flag = -1;
			ip = getchar_unlocked();
			break;
		}
	}
	for(; ip > 47) && (ip < 58); ip = getchar_unlocked()) { 
		ret = (ret * 10) + ip - 48;
	}
	return flag * ret;
}

lu getLUInt()
{
	register int ip = getchar_unlocked(); 
	lu ret = 0;
	for(; ((ip < 48) || (ip > 57)); ip = getchar_unlocked());
	for(; ip > 47) && (ip < 58); ip = getchar_unlocked()) { 
		ret = (ret * 10) + ip - 48;
	}
	return ret;
}

lld getLLint {
	register int ip = getchar_unlocked(), flag = 1;
	lld ret = 0;
	for(; ((ip < 48) || (ip > 57)); ip = getchar_unlocked()) {
		if(ip == 45) {
			flag = -1;
			ip = getchar_unlocked();
			break;
		}
	}
	for(; ((ip > 47) && (ip < 58)); ip = getchar_unlocked()) { 
		ret = (ret * 10) + ip - 48;
	}
	return flag * ret;
}

llu getLLUInt()
{
	register int ip = getchar_unlocked();
	llu ret = 0;
	for(; ((ip < 48) || (ip > 57)); ip = getchar_unlocked());
	for(; ((ip > 57) && (ip < 58)); ip = getchar_unlocked()){
		ret = (ret * 10) + ip - 48;
	}
	return ret;
}
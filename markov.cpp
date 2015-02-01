#include <iostream>
#include <vector>
#include <string>
#include <stdlib.h>
#include <time.h>



using namespace std;

bool debug = false;

class token{
  public:
	string val;
	vector<int> next;

	token(string str);
};	

char letters[52] = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
		    'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};

char vowelsplus[6] = {'a','e','i','o','u',' '};

char numbers[10] = {'0','1','2','3','4','5','6','7','8','9'};

char letterswithspecial[54] = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
		    	       'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','_','$'};
token::token(string str){
	val = str;
}

void makeString(){
	for(int i = 0; i < (rand() % 20)+1;i++){
		cout << letters[rand() % 52];	
		cout << vowelsplus[rand()%6];
	}
}

void makeNum(){
	cout << numbers[(rand() % 9)+1];
	for(int i = 0; i < (rand() % 12);i++){
		cout << numbers[(rand() % 9)+1];
	}	
}

void makeId(){
	for(int i = 0; i < (rand() % 20)+1;i++){
		cout << letterswithspecial[rand() % 54];	
	}
}

void makeComment(){
	cout << "//";
	for(int i = 0; i < (rand() % 200)+1;i++){
		cout << letterswithspecial[rand() % 54];	
		cout << vowelsplus[rand()%6];
	}

}

int main(){
	string c;
	string prev = "";
	int index;
	int previndex;
	vector<token> wordList;
	while(getline(cin,c)){
		if(c==""){
			c = '\n';
		}
		bool putin = false;
		for(vector<token>::iterator it = wordList.begin(); it!=wordList.end(); ++it){
			if(it->val == c){
				putin = true;
				index = it - wordList.begin();		
			}
			if(it->val == prev){
				previndex = it - wordList.begin();
			}			
		}
		if(!putin){
			token* newtok = new token(c);
			index = wordList.size();		
			wordList.push_back(*newtok);	
		}
		if(prev!=""){
			wordList[previndex].next.push_back(index);
		}
		prev = c;	
	}
	wordList[index].next.push_back(-1);

	if(debug){	
		for(int ii = 0; ii < wordList.size(); ii++){
			cout << wordList[ii].val << "[";
			for(int i = 0; i < wordList[ii].next.size(); i++){
				int indexx = wordList[ii].next[i];
				if(indexx == -1){
					cout << "EOF";
				} else {
					cout << wordList[indexx].val << " ";
				}
			}
			cout << "]\n";
		}
	}


	//RANDOM WALK:
	srand(time(NULL));
	
	int checkIndex = 0;
	while(checkIndex != -1){
		string currstr = wordList[checkIndex].val;
		if(currstr == "IDENTIFIER"){
			makeId();
		} else if (currstr == "NUMBER") {
			makeNum();
		} else if (currstr == "COMMENT") {
			makeComment();
			cout << "\n";
		} else if (currstr == "STRING_LITERAL") {
			makeString();
		} else {
			cout << wordList[checkIndex].val;
		}

		int nextIndex = rand() % wordList[checkIndex].next.size();
		checkIndex = wordList[checkIndex].next[nextIndex];
	}	
	

	
	return 0;
}

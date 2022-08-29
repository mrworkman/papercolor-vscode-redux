#include <iostream>

using namespace std;

class CSomeType {

private:
    int m_someInternal;

public:
    CSomeType() {
        m_someInternal = 1;
    }

    ~CSomeType() {

    }

    void mutate() {
        m_someInternal++;
    }
};

/// \brief Something.
int main() {
    auto myType = new CSomeType();

    cout << "Hello, world!" << endl;
    cout << myType << endl;

    try {
        myType->mutate();
    } catch(...) {

    }

    if (1 == 1 || 1 <= 2) {
        // Blah
    }

    cout << myType << endl;

    delete myType;

    return 0;
}

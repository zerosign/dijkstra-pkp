#ifndef READER_H
#define READER_H
#include <string>
#include <fstream>
#include <ios>
#include <sstream>
#include "defs.h"

namespace io {

	class reader {
		public:
			reader();
			static void read(const char*, g::adjmap&);
			static void write(const char*, std::string);
	};
};

#endif

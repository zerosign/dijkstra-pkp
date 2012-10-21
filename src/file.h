#ifndef READER_H
#define READER_H
#include <string>
#include <fstream>
#include <ios>
#include <cstdlib>
#include "defs.h"

namespace io {

	class file {
		public:
			file();
			static void read(const char*, g::adjmap&);
			static void read(const char*, int&,
					float *, float *);
			static void write(const char*, std::string);
	};
};

#endif

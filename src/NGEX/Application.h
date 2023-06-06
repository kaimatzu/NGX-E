#pragma once

#include "Core.h"

namespace NGEX { 
    class NGEX_API Application{
    public:
        Application(/* args */);
        virtual ~Application();

        void Run();
    };
}


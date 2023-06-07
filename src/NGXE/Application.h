#pragma once

#include "Core.h"
#include "Events/Event.h"

namespace NGXE { 
    class NGXE_API Application{
    public:
        Application(/* args */);
        virtual ~Application();

        void Run();
    };

    //To be defined in CLIENT
    Application* CreateApplication();
}


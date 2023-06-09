#include "../ngxepch.h"
#include "Application.h"

#include "Events/ApplicationEvent.h"
#include "Logger.h"

namespace NGXE {
    Application::Application(/* args */){
    }

    Application::~Application(){
    }

    void Application::Run()
    {
        WindowResizeEvent e(1280, 720);
        NGXE_TRACE(e);
        NGXE_INFO("Success");
        while(true){

        }
    }
}

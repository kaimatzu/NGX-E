#pragma once

#ifdef NGXE_PLATFORM_WINDOWS
extern NGXE::Application* NGXE::CreateApplication();

int main(int argc, char** argv) {
    NGXE::Logger::Init();
    NGXE_CORE_WARN("Initialized Log!");
    NGXE_INFO("Hi!");

    auto app = NGXE::CreateApplication();
    app->Run();
    delete app;

    return 0;
}
#endif
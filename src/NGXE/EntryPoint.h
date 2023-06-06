#pragma once

#ifdef NGXE_PLATFORM_WINDOWS
extern NGXE::Application* NGXE::CreateApplication();

int main(int argc, char** argv) {
    auto app = NGXE::CreateApplication();
    app->Run();
    delete app;

    return 0;
}
#endif
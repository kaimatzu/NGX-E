#pragma once

#include "Core.h"
#include "spdlog/spdlog.h"
#include "spdlog/fmt/ostr.h"

namespace NGXE{
    class NGXE_API Logger{
        public:
            static void Init();

            inline static std::shared_ptr<spdlog::logger>& GetCoreLogger() { return s_CoreLogger; }
            inline static std::shared_ptr<spdlog::logger>& GetClientLogger() { return s_ClientLogger; }
        private:
            static std::shared_ptr<spdlog::logger> s_CoreLogger;
            static std::shared_ptr<spdlog::logger> s_ClientLogger;
    };
}

//core log macros
#define NGXE_CORE_TRACE(...)        ::NGXE::Logger::GetCoreLogger()->trace(__VA_ARGS__)
#define NGXE_CORE_INFO(...)         ::NGXE::Logger::GetCoreLogger()->info(__VA_ARGS__)
#define NGXE_CORE_WARN(...)         ::NGXE::Logger::GetCoreLogger()->warn(__VA_ARGS__)
#define NGXE_CORE_ERROR(...)        ::NGXE::Logger::GetCoreLogger()->error(__VA_ARGS__)
#define NGXE_CORE_CRITICAL(...)     ::NGXE::Logger::GetCoreLogger()->critical(__VA_ARGS__)

//client log macros
#define NGXE_TRACE(...)      ::NGXE::Logger::GetClientLogger()->trace(__VA_ARGS__)
#define NGXE_INFO(...)       ::NGXE::Logger::GetClientLogger()->info(__VA_ARGS__)
#define NGXE_WARN(...)       ::NGXE::Logger::GetClientLogger()->warn(__VA_ARGS__)
#define NGXE_ERROR(...)      ::NGXE::Logger::GetClientLogger()->error(__VA_ARGS__)
#define NGXE_CRITICAL(...)   ::NGXE::Logger::GetClientLogger()->critical(__VA_ARGS__)

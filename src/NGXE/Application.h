#pragma once

#include "Core.h"
#include "Events/Event.h"
#include "Window.h"

namespace NGXE { 
	class NGXE_API Application{
	public:
		Application(/* args */);
		virtual ~Application();

		void Run();

	private:
		std::unique_ptr<Window> m_Window;
		bool m_Running = true;

	};

	//To be defined in CLIENT
	Application* CreateApplication();
}


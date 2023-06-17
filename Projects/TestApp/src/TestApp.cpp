#include "NGXE.h"


class ExampleLayer : public NGXE::Layer
{
public:
	ExampleLayer()
		: Layer("Example"){ }

	void OnUpdate() override{
		NGXE_INFO("ExampleLayer::Update");
	}

	void OnEvent(NGXE::Event& event) override{
		NGXE_TRACE("{0}", event);
    }

};
class TestApp : public NGXE::Application {

public:
    TestApp(){
        PushLayer(new ExampleLayer());
    }

    ~TestApp(){

    }
};

NGXE::Application* NGXE::CreateApplication(){
    return new TestApp();
}
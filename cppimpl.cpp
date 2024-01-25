#include "ffigen_app.h"
#include <memory>
#include <vector>

//#1
class A {
	private:
		int value;
	public:
		A(int val);
		~A();
		void setValue(int val);
		int getValue();
};

//#2
class A_Container {
	private:
		std::vector<std::shared_ptr<A>> container;
	public:
		A_Container();
		~A_Container();
		void storePtr(std::shared_ptr<A>*);
		std::shared_ptr<A>* getPtr(int idx);
};

//#1
A::A(int val) {
	printf("An object is generated\n");
	value = val;
	printf("The initial value is %d\n", val);
}
A::~A() {
	printf("An object with %d as its value is destroyed\n", value);
}
void A::setValue(int val) {
	value = val;
	printf("The value property is set to %d\n", val);
}
int A::getValue() {
	printf("The value property of this object is %d\n", value);
	return value;
}
FFI_PLUGIN_EXPORT void* create_A() {
	//1. create an object of type A
	//2. create a shared_ptr of type A
	//3. return the shared_ptr
	//4. the shared_ptr will be converted to a void* and returned to the caller
	auto* obj = new std::shared_ptr<A>(new A(0));
	//convert the shared_ptr to a void*
	return reinterpret_cast<void*>(obj);
}
FFI_PLUGIN_EXPORT void release_A(void *obj) {
	auto* del = reinterpret_cast<std::shared_ptr<A>*>(obj);
	delete del;
}
FFI_PLUGIN_EXPORT void set_Value(void *obj, int val) {
	reinterpret_cast<std::shared_ptr<A>*>(obj)->get()->setValue(val);
}
FFI_PLUGIN_EXPORT int get_Value(void *obj) {
	auto val = reinterpret_cast<std::shared_ptr<A>*>(obj)->get()->getValue();
	return val;
}
FFI_PLUGIN_EXPORT int refCount(void* obj) {
	return reinterpret_cast<std::shared_ptr<A>*>(obj)->use_count();
}


//#2
A_Container::A_Container() {
	container = std::vector<std::shared_ptr<A>>();
	printf("A container for class A objects is generated.\n");
}
A_Container::~A_Container() {
	printf("A container for class A objects is destroyed\n");
}
void A_Container::storePtr(std::shared_ptr<A> *ptr) {
	container.push_back(*ptr);
	printf("A shared pointer of A(pointer address: %p, object address: %p) is successfully stored in the container vector\n", ptr, ptr->get());
}
std::shared_ptr<A>* A_Container::getPtr(int idx) {
	printf("Successfully accessed a shared pointer of A at index #%d\n", idx);
	return &(container.at(idx));
}
FFI_PLUGIN_EXPORT void* create_A_Container() {
	auto* container = new A_Container();
	return reinterpret_cast<void*>(container);
}
FFI_PLUGIN_EXPORT void release_A_Container(void *obj) {
	auto* del = reinterpret_cast<A_Container*>(obj);
	delete del;
}
FFI_PLUGIN_EXPORT void storePtr(void *container, void* target) {
	auto* val = reinterpret_cast<std::shared_ptr<A>*>(target);
	reinterpret_cast<A_Container*>(container)->storePtr(val);
}
FFI_PLUGIN_EXPORT void* getPtr(void* container, int idx) {
	auto* target = reinterpret_cast<A_Container*>(container)->getPtr(idx);
	return target;
}

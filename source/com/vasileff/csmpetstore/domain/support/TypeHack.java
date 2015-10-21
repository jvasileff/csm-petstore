package com.vasileff.csmpetstore.domain.support;

import ceylon.language.Sequential;
import ceylon.language.meta.model.Attribute;
import ceylon.language.meta.model.Method;

import com.redhat.ceylon.compiler.java.runtime.metamodel.meta.AttributeImpl;
import com.redhat.ceylon.compiler.java.runtime.metamodel.meta.MethodImpl;
import com.redhat.ceylon.compiler.java.runtime.model.TypeDescriptor;
import com.redhat.ceylon.compiler.java.runtime.model.TypeDescriptor.Generic;
import com.vasileff.proxy.InvocationHandler;

public class TypeHack {

    @SuppressWarnings({ "unchecked", "rawtypes" })
    public static <Container> void trustMeSet(
            InvocationHandler<Container> ih,
            Object attribute, Object target, Object val) {
        AttributeImpl<?, ?, ?> appliedAttribute = (AttributeImpl<?, ?, ?>) attribute;
        TypeDescriptor[] types = ((Generic)appliedAttribute.$getType$()).getTypeArguments();
        TypeDescriptor getType = types[1];
        TypeDescriptor setType = types[2];
        ((InvocationHandler)ih).setAttribute(
                getType,  setType, target, (Attribute) attribute, val);
    }

    @SuppressWarnings({ "unchecked", "rawtypes" })
    public static <Container> Object trustMeGet(
            InvocationHandler<Container> ih,
            Object attribute, Object target) {
        AttributeImpl<?, ?, ?> appliedAttribute = (AttributeImpl<?, ?, ?>) attribute;
        TypeDescriptor[] types = ((Generic)appliedAttribute.$getType$()).getTypeArguments();
        TypeDescriptor getType = types[1];
        TypeDescriptor setType = types[2];
        return ((InvocationHandler)ih).getAttribute(
                getType, setType, target, (Attribute) attribute);
    }

    @SuppressWarnings({ "unchecked", "rawtypes" })
    public static <Container> Object trustMeInvoke(
            InvocationHandler<Container> ih,
            Object method, Object target, Object arguments) {
        MethodImpl<?, ?, ?> appliedMethod = (MethodImpl<?, ?, ?>) method;
        TypeDescriptor[] types = ((Generic)appliedMethod.$getType$()).getTypeArguments();
        TypeDescriptor returnType = types[1];
        TypeDescriptor argumentsType = types[2];
        return ((InvocationHandler)ih).invoke(
                returnType, argumentsType, target, (Method) method, (Sequential) arguments);
    }
}

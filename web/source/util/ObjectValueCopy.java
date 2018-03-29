package com.xl.pay.util;

import com.xl.pay.exception.BaseException;

import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ObjectValueCopy {

    //复制对象值
    public static void copyValue(List<String> props, Object source, Object target) {
        Field[] sourceFields = source.getClass().getDeclaredFields();
        Field[] targetFields = target.getClass().getDeclaredFields();

        HashMap<String, Field> sourceMap = new HashMap<>(sourceFields.length);
        HashMap<String, Field> targetMap = new HashMap<>(targetFields.length);
        for (Field f : sourceFields) {
            f.setAccessible(true);
            sourceMap.put(f.getName(), f);
        }

        for (Field f : targetFields) {
            f.setAccessible(true);
            targetMap.put(f.getName(), f);
        }
        for (String prop : props) {
            if (sourceMap.containsKey(prop) && targetMap.containsKey(prop)) {
                try {
                    Object v = sourceMap.get(prop).get(source);
                    if (v != null){
                        targetMap.get(prop).set(target, v);
                    }
                } catch (IllegalAccessException e) {
                    e.printStackTrace();
                }
            }
        }

    }

    //从map中拷贝
    public static void copyValue(Map<String, Boolean> props, Map<String, String> source, Object target) throws BaseException {
        for (Map.Entry<String, Boolean> entry : props.entrySet()) {

            if (!source.containsKey(entry.getKey())) {
                if (entry.getValue()) {
                    throw new BaseException(901, "元数据缺少必要字段" + entry.getKey());
                }
            } else {
                String o = source.get(entry.getKey());
                if (o == null) {
                    if (entry.getValue()) {
                        throw new BaseException(901, "元数据缺少必要字段" + entry.getKey());
                    }
                } else {
                    try {
                        Field f = target.getClass().getDeclaredField(entry.getKey());
                        f.setAccessible(true);
                        Class<?> type = f.getType();
                        Object value = convert(type, o);
                        f.set(target, value);
                    } catch (NoSuchFieldException | IllegalAccessException e) {
                        continue;
                    }
                }
            }
        }
    }

    //判断类型转换
    private static Object convert(Class cls, String value) {
        Object o = null;
        switch (cls.getTypeName()) {
            case "java.lang.String": {
                o = value;
                break;
            }
            case "java.lang.Integer": {
                o = Integer.parseInt(value);
                break;
            }
            case "java.lang.Boolean": {
                o = Boolean.parseBoolean(value);
                break;
            }
            case "int": {
                o = Integer.parseInt(value);
                break;
            }
            default:{

            }
        }
        return o;
    }


}

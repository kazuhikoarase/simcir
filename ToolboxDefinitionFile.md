# Toolbox Definition File #

The Toolbox Definition File defines  [a list of devices](http://simcir.googlecode.com/svn/assets/toolbox/BasicSet.png).

```
<?xml version="1.0" encoding="UTF-8" ?>
<simcir xmlns="http://www.d-project.com/simcir/2012" title="BasicSet">
	<device type="In" />
	<device type="Out" />
	<device factory="/BasicSet.swf" type="DC" />
	<device factory="/BasicSet.swf" type="PushOn" />
	<device factory="/BasicSet.swf" type="PushOff" />
	<device factory="/BasicSet.swf" type="Toggle" />
	<device factory="/BasicSet.swf" type="LED" />
	<device factory="/BasicSet.swf" type="BUF" />
	<device factory="/BasicSet.swf" type="NOT" />
	<device factory="/BasicSet.swf" type="AND" />
	<device factory="/BasicSet.swf" type="NAND" />
	<device factory="/BasicSet.swf" type="OR" />
	<device factory="/BasicSet.swf" type="NOR" />
	<device factory="/BasicSet.swf" type="EOR" />
	<device factory="/BasicSet.swf" type="ENOR" />
	<device factory="/BasicSet.swf" type="OSC" />
	<device factory="/BasicSet.swf" type="7seg" />
	<device factory="/BasicSet.swf" type="4bit7seg" label="4bit 7seg" />
	<device factory="/BasicSet.swf" type="4bitVol" label="4bit Volume" />
</simcir>
```

## Simcir Element ##

The simcir element is a root element of a file.

| **Attribute** | **Required** | **Description** |
|:--------------|:-------------|:----------------|
| title | No | Title of a toolbox. |

## Device Element ##

The device element defines a device.

| **Attribute** | **Required** | **Description** |
|:--------------|:-------------|:----------------|
| factory | Yes | URL of a factory that provides a device. If absence, it treated as a built in factory. URL need to be an absolute path. |
| type | Yes | Type name of a device. |
| label | No | Label of a device. If absence, type attribute is applied. |

## Param Element ##

Optionally, the device element could have the param elements.

| **Attribute** | **Required** | **Description** |
|:--------------|:-------------|:----------------|
| name | Yes | Name of parameter |
| value | Yes | Value of parameter |

```
<device factory="/BasicSet.swf" type="NAND" label="NAND(3in)">
	<param name="numInputs" value="3"/>
</device>
```
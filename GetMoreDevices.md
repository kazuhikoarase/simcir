# Get More Devices #

Here is a [Toolbox Definition File](ToolboxDefinitionFile.md) of the BasicSet you see at first.
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

Some device in the BasicSet could have additional parameters.

Gate (except BUF and NOT) could change a number of inputs by the parameter 'numInputs'.

LED could change a color by the parameter 'color'.

```
<?xml version="1.0" encoding="UTF-8" ?>
<simcir xmlns="http://www.d-project.com/simcir/2012" title="MoreSet">
	<device factory="/BasicSet.swf" type="NAND" label="NAND(3in)">
		<param name="numInputs" value="3"/>
	</device>
	<device factory="/BasicSet.swf" type="LED" label="LED(Y)">
		<param name="color" value="#ffff00" />
	</device>
	<device factory="/BasicSet.swf" type="7seg" label="7seg(Y)">
		<param name="color" value="#ffff00" />
	</device>
	<device factory="/BasicSet.swf" type="4bit7seg" label="4bit 7seg(Y)">
		<param name="color" value="#ffff00" />
	</device>
</simcir>
```

For example, open the toolbox menu and replace 'http://' with '[/MoreSet.xml](http://simcironline.appspot.com/MoreSet.xml)' and press plus button.

![http://simcir.googlecode.com/svn/assets/toolbox/AddToolbox1_2.png](http://simcir.googlecode.com/svn/assets/toolbox/AddToolbox1_2.png)

Then 'MoreSet' will be added.

![http://simcir.googlecode.com/svn/assets/toolbox/AddToolbox3.png](http://simcir.googlecode.com/svn/assets/toolbox/AddToolbox3.png)

You could deploy custom [Toolbox Definition File](ToolboxDefinitionFile.md) on your site.
Please beware to a [crossdomain.xml](CrossDomain.md) required at host root.

```
http://www.example.com/YourSet.xml
                      /crossdomain.xml
```

In additionally, you could create a custom device with
[SDK](http://code.google.com/p/simcir/downloads/list).
A type 2 diabetes risk calculator based on the UKPDS model

>
> Most recent version is broken, calculating incorrect intervention risks
>

To restart the debug, use
```
git bisect start HEAD 4e9c21f83af92c3dc9f82355caee313e6fa0dba1
```

4e9c21f83af92c3dc9f82355caee313e6fa0dba1 is the last known working model.

Base risks are calculated correctly, but interventions are wildly off.
There have been changes in the UKPDSModel.as, but replacing the HEAD file with the
version from the working commit changes nothing.

Main suspect is the UserModel/Parameter interaction.
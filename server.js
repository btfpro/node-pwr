/*
"use strict";

const PowerShell = require("powershell/lib");

// Start the process
let ps = new PowerShell("echo 'powershell is awesome");

// Handle process errors (e.g. powershell not found)
ps.on("error", err => {
    console.error(err);
});

// Stdout
ps.on("output", data => {
    console.log(data);
});

// Stderr
ps.on("error-output", data => {
    console.error(data);
});

// End
ps.on("end", code => {
    // Do Something on end
});

*/



"use strict";

const PowerShell = require("powershell/lib");

// Start the process
let ps = new PowerShell("./sol.ps1",{PSCore:true});

// Handle process errors (e.g. powershell not found)
ps.on("error", err => {
    console.error(err);
});

// Stdout
ps.on("output", data => {
    console.log(data);
});

// Stderr
ps.on("error-output", data => {
    console.error(data);
});

// End
ps.on("end", code => {
    // Do Something on end
});
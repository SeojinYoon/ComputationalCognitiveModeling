
# Stan's program blocks 

https://mc-stan.org/docs/reference-manual/overview-of-stans-program-blocks.html

functions {  
  // ... function declarations and definitions ...  
}  
data {  
  // ... declarations ...  
}  
transformed data {  
   // ... declarations ... statements ...  
}  
parameters {  
   // ... declarations ...  
}  
transformed parameters {  
   // ... declarations ... statements ...  
}  
model {  
   // ... declarations ... statements ...  
}  
generated quantities {  
   // ... declarations ... statements ...  
}  

Following lines explains program block in stan and each number is order of program block.

1. Functions Block:  
This block is used to define custom functions that you may need in your model. It's optional and is placed at the beginning if needed.
2. Data Block:  
In the data block, you declare and define the data that your model will use. This includes observed data, constants, and any data-related transformations.
3. Transformed Data Block:  
In the transformed data block, you can perform additional data transformations that are not parameters or quantities of interest but are necessary for your model. This block is used for precomputations.
4. Parameters Block:  
In the parameters block, you declare the model's parameters. These are the variables that the sampling algorithm will adjust to fit the data.
5. Transformed Parameters Block:  
In the transformed parameters block, you can declare variables that are functions of the model parameters. This is where you compute derived quantities or transformations of parameters.
6. Model Block:  
The model block is where you define the likelihood and prior distributions. It's also where you specify the model's structure, including how the data is generated. This is the core of your Bayesian model.
7. Generated Quantities Block:  
In the generated quantities block, you define and compute quantities of interest that are derived from the posterior samples of the model parameters. These are typically quantities you want to analyze or report after the sampling is complete.

import os
import argparse


parser = argparse.ArgumentParser (description="copy result")

# Arguments
parser.add_argument("--modelpath", required=False, default="./", help="Path to the directory, model")
parser.add_argument("--savepath", required=False, default="./picked/", help="Path where the result files are copied")


args = parser.parse_args()


# Function
def copy (modelpath = args.modelpath, savepath = args.savepath):

    result = ["model_1.pdb", "model_2.pdb", "model_3.pdb", "model_4.pdb", "model_5.pdb"]

    os.mkdir (savepath)

    with open (f"{savepath}/log.txt", "a") as log:
        for i in result:
            j = os.path.realpath(f"{modelpath}/{i}")
            os.system (f"cp {j} {savepath}/{i}")
            log.write(i)
            log.write("-----")
            log.write(j[-29:-1] + "\n")


# Run
if __name__ == '__main__':
    copy (
            modelpath = args.modelpath, 
            savepath = args.savepath
    )

    print ("Copy finished")
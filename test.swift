//import UIKit
//
//    class RecipeCollViewController: UICollectionViewController, UITextFieldDelegate
//    {
//        struct Storyboard
//        {
//            static let leftAndRightPaddings: CGFloat = 2.0
//            static let numberOfItemsPerRow: CGFloat = 2.0
//        }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        RecipeDataManager.shared.recipeController = self
//
//        title = loc("TITLE_RECIPECOLL")
//
//        navigationController?.navigationBar.prefersLargeTitles = true
//
//        let collectionViewWidth = collectionView?.frame.width
//        let itemWidth = (collectionViewWidth! -  Storyboard.leftAndRightPaddings) / Storyboard.numberOfItemsPerRow
//
//        let layout = collectionViewLayout as! UICollectionViewFlowLayout
//        layout.itemSize = CGSize(width: itemWidth, height: 250)
//    }
//
//    override func numberOfSections(in collectionView: UICollectionView) -> Int
//    {
//        return 1
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
//    {
//        return RecipeDataManager.shared.recipes.count
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
//    {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCell", for: indexPath) as! RecipeViewCell
//        let recipe = RecipeDataManager.shared.recipes[indexPath.item]
//
//        cell.labelNameRecipe.text = recipe.titleRecipe
//        cell.imageViewRecipe.image = recipe.imageRecipe
//        cell.labelPrepareTime.text = String(recipe.recipeTimeInt)
//        cell.labelPeopleFor.text = recipe.peopleRecipe
//
//        return cell
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
//    {
//
//    }
//
//
//    // MARK: - NAVIGAZIONE
//    // Metodo che scatta quando l'utente tocca una delle celle della collectionView e apre il dettaglio
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
//    {
//        if segue.identifier == "RecipeDetail"
//        {
//            if let indexPath = self.collectionView!.indexPathsForSelectedItems?.first
//            {
//                let recipeDetailVC = segue.destination as! DetailRecipeViewController
//                recipeDetailVC.recipe = RecipeDataManager.shared.recipes[indexPath.item]
//            }
//        }
//    }
//
//// MARK: - UILongPressGestureRecognizer function for the cell recipe
//
//@IBAction func popUpActionCell(longPressGesture : UILongPressGestureRecognizer)
//{
//    let alertActionCell = UIAlertController(title: "Action Recipe Cell", message: "Choose an action for the selected recipe", preferredStyle: .actionSheet)
//
//    // Configure Remove Item Action
//    let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { action in
//
//        // Delete selected Cell
//        let deleteRecipe: [RecipeDataManager] = []
//        if let indexPath = self.collectionView?.indexPathsForSelectedItems?.first
//        {
//            RecipeDataManager.shared.recipes.remove(at: indexPath.item)
//            RecipeDataManager.shared.salva()
//            self.collectionView?.deleteItems(at: [indexPath])
//        }
//
//        print("Cell Removed")
//    })
//
//    // Configure Cancel Action Sheet
//    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { acion in
//        print("Cancel actionsheet")
//    })
//
//    alertActionCell.addAction(deleteAction)
//    alertActionCell.addAction(cancelAction)
//    self.present(alertActionCell, animated: true, completion: nil)
//
//    self.collectionView!.reloadData()
//}
//
//
//}

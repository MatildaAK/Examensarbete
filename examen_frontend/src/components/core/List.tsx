interface ListProps {
  items: { title: string; value: React.ReactNode }[];
  renderSlot: (item: { title: string; value: React.ReactNode }) => React.ReactNode;
}

const List: React.FC<ListProps> = ({ items, renderSlot }) => {
  return (
    <div className="mt-14">
      <dl className="divide-border -my-4 divide-y">
        {items.map((item, i) => (
          <div key={i} className="flex gap-4 py-4 text-sm leading-6 border sm:gap-8">
            <dt className="w-1/4 flex-none text-accent0">{item.title}</dt>
            <dd className="text-accent-foreground">{renderSlot(item)}</dd>
          </div>
        ))}
      </dl>
    </div>
  );
};


export default List;